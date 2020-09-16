#!/bin/bash -

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

OLD_PATH=$(pwd)

RETURN_BASE_ARGS_PY_FILE="${FXSCRIPT_FULL_HRENDER_DIR}/return_base_args.py"
ARGS=$(python "${RETURN_BASE_ARGS_PY_FILE}" $*)

FXUSER=`echo $ARGS | awk -F' ' '{print $1}'`
HOUDINI_VERSION=`echo $ARGS | awk -F' ' '{print $2}'`
FXHOME=`echo $ARGS | awk -F' ' '{print $3}'`
FXHOMEBRG=`echo $ARGS | awk -F' ' '{print $4}'`
COMMON=`echo $ARGS | awk -F' ' '{print $5}'`
FXSHOW=`echo $ARGS | awk -F' ' '{print $6}'`
HFILE=`echo $ARGS | awk -F' ' '{print $7}'`
DRIVER=`echo $ARGS | awk -F' ' '{print $8}'`
SFRAME=`echo $ARGS | awk -F' ' '{print $9}'`
EFRAME=`echo $ARGS | awk -F' ' '{print $10}'`
NODEPS=`echo $ARGS | awk -F' ' '{print $11}'`
RENDERDIR=`echo $ARGS | awk -F' ' '{print $12}'`
ENV_HIP=`echo $ARGS | awk -F' ' '{print $13}'`
ENV_HIPNAME=`echo $ARGS | awk -F' ' '{print $14}'`
ENV_HIPFILE=`echo $ARGS | awk -F' ' '{print $15}'`
NO_SQL=`echo $ARGS | awk -F' ' '{print $16}'`
ONLY_ENV=`echo $ARGS | awk -F' ' '{print $17}'`

if [[ ${NODEPS} == 0 ]];then
	NODEPS=""
else
	NODEPS="-s"
fi

if [[ ${RENDERDIR} == 0 ]];then
	RENDERDIR=""
fi

if [[ ${ENV_HIP} == 0 ]];then
	ENV_HIP=""
fi

if [[ ${ENV_HIPNAME} == 0 ]];then
	ENV_HIPNAME=""
fi

if [[ ${ENV_HIPFILE} == 0 ]];then
	ENV_HIPFILE=""
fi

FRAME_SIGNAL="-f"
if [[ ${SFRAME} == -1 && ${EFRAME} == -1 ]];then
	SFRAME=
	EFRAME=
	FRAME_SIGNAL=
fi

function DEBUG_OPT()
{
    echo "FXUSER: ${FXUSER}"
    echo "HOUDINI_VERSION: ${HOUDINI_VERSION}"
    echo "FXHOME: ${FXHOME}"
    echo "FXHOMEBRG: ${FXHOMEBRG}"
    echo "COMMON: ${COMMON}"
    echo "FXSHOW: ${FXSHOW}"
    echo "HFILE: ${HFILE}"
    echo "DRIVER: ${DRIVER}"
    echo "SFRAME: ${SFRAME}"
    echo "EFRAME: ${EFRAME}"
    echo "FRAME_SIGNAL: ${FRAME_SIGNAL}"
    echo "NODEPS: ${NODEPS}"
    echo "RENDERDIR: ${RENDERDIR}"
    echo "ENV_HIP: ${ENV_HIP}"
    echo "ENV_HIPNAME: ${ENV_HIPNAME}"
    echo "ENV_HIPFILE: ${ENV_HIPFILE}"
    echo "NO_SQL: ${NO_SQL}"
    echo "ONLY_ENV: ${ONLY_ENV}"
}
# TODO (2019.01.08): 주석처리 함.
# DEBUG_OPT


if [[ ! -f ${HFILE} ]];then
    echo
    echo "HIP File Not Found!!!"
    echo
    exit 55
fi


if [[ -d ${FXHOME} ]];then
	source "${FXSCRIPT_FULL_MODULES_ENV_DIR}/houdini_env.sh" ${FXUSER} ${HOUDINI_VERSION} ${FXHOME} ${FXHOMEBRG} ${COMMON} ${FXSHOW} 0 ${NO_SQL}

	if [[ "${FXSHOW}" == "1" ]];then
		#echo "--------------------------------------------------------------"
		#echo -e '\e[0;33m' "PYTHONPATH : " '\e[0;32m' "${PYTHONPATH}"
		#tput sgr0
		#echo "PYTHONPATH : ""${PYTHONPATH}"
		#echo "--------------------------------------------------------------"
		:
	fi

    ######################### UnSet Variables #########################
    source "${FXSCRIPT_FULL_DIR}/unset.sh" "render"
    ###################################################################

    ########################## Set Variables ##########################
    export FXHOME
    ###################################################################

	echo
	echo "Houdini Version: $HOUDINI_VERSION"
	echo `date +'%Y-%m-%d %H:%M:%S'`
	echo "${FXUSER} - Start Render"
	echo

	cd $OLD_PATH

    # TODO (2019.01.08): 주석처리 함.
	# echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	# echo "DEF_OPT_DIR: ${DEF_OPT_DIR}"
	# echo "DEF_HOU_BRG: ${DEF_HOU_BRG}"
	# echo "HOUDINI_VERSION: ${HOUDINI_VERSION}"
	# echo "----------------------------------------------------------------------------------"
	# echo "HFILE: ${HFILE}"
	# echo "----------------------------------------------------------------------------------"
	# echo "ENV_HIP: ${ENV_HIP}"
	# echo "ENV_HIPNAME: ${ENV_HIPNAME}"
	# echo "ENV_HIPFILE: ${ENV_HIPFILE}"
	# echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	# echo


    RUN_TYPE="python"
    #RUN_TYPE="shell"

    echo "Run Type: ${RUN_TYPE}"
    # TODO (2019.01.08): 주석처리 함.
	# echo "ALL Parameters: $*"

	if [[ "${RUN_TYPE}" == "shell" ]];then
	"/${DEF_OPT_DIR}/${DEF_HOU_BRG}${HOUDINI_VERSION}/bin/hbatch" "${HFILE}" <<- EOF!
	set -g HIP = ${ENV_HIP}
	varchange "HIP"
	set -g HIPNAME = ${ENV_HIPNAME}
	varchange "HIPNAME"
	set -g HIPFILE = ${ENV_HIPFILE}
	varchange "HIPFILE"

	#echo "=================================== DEBUG ==================================="
	#echo "render -V -I ${NODEPS} ${FRAME_SIGNAL} ${SFRAME} ${EFRAME} ${DRIVER} ${RENDERDIR}"
	#echo "============================================================================="

	render -V -I ${NODEPS} ${FRAME_SIGNAL} ${SFRAME} ${EFRAME} ${DRIVER} ${RENDERDIR}
	EOF!
	elif [[ "${RUN_TYPE}" == "python" ]];then
	    echo "##########################################################################"
        exec hython "${FXSCRIPT_FULL_HRENDER_DIR}/hrender.py" -I -v $*
	    echo "##########################################################################"
    else
        echo "Select Run Type -> Shell or Python"
	fi

fi



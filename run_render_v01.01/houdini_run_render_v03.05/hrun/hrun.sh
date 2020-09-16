#!/bin/bash -

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

RETURN_ARGS_PY_FILE="${FXSCRIPT_FULL_HRUN_DIR}/return_args.py"
ARGS=$(python "${RETURN_ARGS_PY_FILE}" $*)

FXUSER=`echo ${ARGS} | awk -F' ' '{print $1}'`
HOUDINI_VERSION=`echo ${ARGS} | awk -F' ' '{print $2}'`
FXHOME=`echo ${ARGS} | awk -F' ' '{print $3}'`
FXHOMEBRG=`echo ${ARGS} | awk -F' ' '{print $4}'`
COMMON=`echo ${ARGS} | awk -F' ' '{print $5}'`
NEVER_OP=`echo ${ARGS} | awk -F' ' '{print $6}'`
FXSHOW=`echo ${ARGS} | awk -F' ' '{print $7}'`
NO_HISTORY=`echo ${ARGS} | awk -F' ' '{print $8}'`
NO_SQL=`echo ${ARGS} | awk -F' ' '{print $9}'`
ONLY_ENV=`echo ${ARGS} | awk -F' ' '{print $10}'`
HIPFILE_OP=`echo ${ARGS} | awk -F' ' '{print $11}'`

function DEBUG_OPT()
{
    echo ${FXUSER}
    echo ${HOUDINI_VERSION}
    echo ${FXHOME}
    echo ${FXHOMEBRG}
    echo ${COMMON}
    echo ${NEVER_OP}
    echo ${FXSHOW}
    echo ${NO_HISTORY}
    echo ${NO_SQL}
    echo ${ONLY_ENV}
    echo ${HIPFILE_OP}
}
#DEBUG_OPT

if [[ -d ${FXHOME} ]];then
    source "${FXSCRIPT_FULL_MODULES_ENV_DIR}/houdini_env.sh" ${FXUSER} ${HOUDINI_VERSION} ${FXHOME} ${FXHOMEBRG} ${COMMON} ${FXSHOW} ${NO_HISTORY} ${NO_SQL}

    if [[ ${FXSHOW} == "1" ]];then
        #echo "--------------------------------------------------------------"
        #echo -e '\e[0;33m' "PYTHONPATH : " '\e[0;32m' "${PYTHONPATH}"
        #tput sgr0
        #echo "PYTHONPATH : ""${PYTHONPATH}"
        #echo "--------------------------------------------------------------"
        :
    fi

    # info
    #echo "0" $BASE_DIR              -> /Rnd/FX/houdini/scripts/RunRender_v01.01
    #echo "1" $FXSCRIPT              -> scripts
    #echo "2" $FXSCRIPT_ROOT         -> wswgs__houdini__run__render_v03.01
    #echo "3" $FXSCRIPT_FULL_DIR     -> /Rnd/FX/houdini/scripts/RunRender_v01.01/wswgs__houdini__run__render_v03.01
    #echo "4" $FXHOME_DIR            -> /Rnd/FX/houdini
    #

    ######################### UnSet Variables #########################
    source "${FXSCRIPT_FULL_DIR}/unset.sh" "run"
    ###################################################################

    ########################## Set Variables ##########################
    export FXHOME
    ###################################################################

    echo
    echo "Houdini Version: ${HOUDINI_VERSION}"
    echo `date`
    echo "${FXUSER} - Start Houdini With Environments"

    if [[ ${ONLY_ENV} == 0 ]];then
        if [[ ${NEVER_OP} != 0 ]];then
            echo
            echo "Run Command: houdinifx -n ${HIPFILE_OP}"
            echo
            houdinifx -n ${HIPFILE_OP} &
        else
            echo
            echo "Run Command: houdinifx ${HIPFILE_OP}"
            echo
            houdinifx ${HIPFILE_OP} &
        fi
        echo "Terminal PID: $$"
#        echo "Houdini PID: $(( $!+4 ))"
    fi

else
    echo "${FXHOME} directory not exists!!"
fi

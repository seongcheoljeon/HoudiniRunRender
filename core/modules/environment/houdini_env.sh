#!/bin/csh -f

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

# variables
FXUSER="$1"
__HOUDINI_VERSION__="$2"
FXHOME="$3"
FXHOMEBRG="$4"
COMMON="$5"
FXSHOW="$6"
NO_HISTORY="$7"
NO_SQL="$8"

# constant
FXHOMEUSER="${FXHOME}/${FXHOMEBRG}"
ERROR=127
SUCCESS=0
TRUE=1
FALSE=0


function _HoudiniVersionSplit()
{
    local __verFieldCnt=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print NF}'`
    if [[ ${__verFieldCnt} == 4 ]];then
        MAJOR_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $1}'`
        MINOR_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $2}'`
        PATCH_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $3"."$4}'`
    else
        MAJOR_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $1}'`
        MINOR_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $2}'`
        PATCH_VERSION=`echo ${__HOUDINI_VERSION__} | awk -F'.' '{print $3}'`
    fi
}
# houdini version split. ex) 15.0.313 -> MAJOR_VERSION:15, MINOR_VERSION:0, PATCH_VERSION:313
_HoudiniVersionSplit
###############################################


function _MakeDirectory()
{
    local DIRPATH="$1"
    if [ ! -d "${DIRPATH}" ];then
        mkdir -p "${DIRPATH}"
        if [[ $? == ${SUCCESS} ]];then
            echo "${DIRPATH} Directory Created!"
        else
            echo
            echo -e '\e[0;31m' "${DIRPATH} Directory failed"
            tput sgr0
            echo
            exit ${ERROR}
        fi
    fi
}


function _MakeFile()
{
    local FILEPATH="$1"
    if [ ! -f "${FILEPATH}" ];then
        touch ${FILEPATH}
        if [[ $? == ${SUCCESS} ]];then
            echo "${FILEPATH} File Created!"
        else
            echo
            echo -e '\e[0;31m' "${FILEPATH} File failed"
            tput sgr0
            echo
            exit ${ERROR}
        fi
    fi
}


function _ConstantString()
{
    __HOUDINI_STR__="houdini"
    __SCRIPTS_STR__="scripts"
    __PYTHON_STR__="python"
    __OTLS_STR__="otls"
    __TOOLBAR_STR__="toolbar"
    __DSO_STR__="dso"
    __PYTHONPANELS_STR__="python_panels"
    __VEX_STR__="vex"
    __CONFIG_STR__="config"
    __ICONS_STR__="Icons"
    __ASSETSTORE_STR__="asset_store"
}


function _PersonEnvironment()
{
    _ConstantString
    HOUDINI_USER_HOME="${FXHOMEUSER}/${FXUSER}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    PERSONAL_SCRIPTS_PATH="${HOUDINI_USER_HOME}/${__SCRIPTS_STR__}"
    PERSONAL_SCRIPTS_PYTHON_PATH="${PERSONAL_SCRIPTS_PATH}/${__PYTHON_STR__}"
    PERSONAL_OTL_PATH="${HOUDINI_USER_HOME}/${__OTLS_STR__}"
    PERSONAL_TOOLBAR_PATH="${HOUDINI_USER_HOME}/${__TOOLBAR_STR__}"
    PERSONAL_DSO_PATH="${HOUDINI_USER_HOME}/${__DSO_STR__}"
    PERSONAL_PYTHON_PANEL_PATH="${HOUDINI_USER_HOME}/${__PYTHONPANELS_STR__}"
    PERSONAL_VEX_PATH="${HOUDINI_USER_HOME}/${__VEX_STR__}"
    PERSONAL_UI_ICON_PATH="${HOUDINI_USER_HOME}/${__CONFIG_STR__}/${__ICONS_STR__}"
    PERSONAL_ASSET_STORE_PATH="${HOUDINI_USER_HOME}/${__ASSETSTORE_STR__}"
    PERSONAL_USER_PREF_DIR_PATH="${HOUDINI_USER_HOME}"
    # REDSHIFT PATH
#    PERSONAL_REDSHIFT_PATH="/usr/redshift/bin"
#    PERSONAL_REDSHIFT_HOUDINI_PATH="/usr/redshift/redshift4houdini/16.0.736"
#    PERSONAL_REDSHIFT_HOUDINI_DSO_PATH="/usr/redshift/redshift4houdini/16.0.736/dso"
}


function _CommonHoudiniHomeEnvironment()
{
    COMMON_DIR="${FXHOME}/${COMMON}"
    COMMON_HOUDINI_HOME="${COMMON_DIR}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    COMMON_HOUDINI_HOME_SCRIPTS_PATH="${COMMON_HOUDINI_HOME}/${__SCRIPTS_STR__}"
    COMMON_HOUDINI_HOME_SCRIPTS_PYTHON_PATH="${COMMON_HOUDINI_HOME_SCRIPTS_PATH}/${__PYTHON_STR__}"
    COMMON_HOUDINI_HOME_OTL_PATH="${COMMON_HOUDINI_HOME}/${__OTLS_STR__}"
    COMMON_HOUDINI_HOME_TOOLBAR_PATH="${COMMON_HOUDINI_HOME}/${__TOOLBAR_STR__}"
    COMMON_HOUDINI_HOME_DSO_PATH="${COMMON_HOUDINI_HOME}/${__DSO_STR__}"
    COMMON_HOUDINI_HOME_PYTHON_PANEL_PATH="${COMMON_HOUDINI_HOME}/${__PYTHONPANELS_STR__}"
    COMMON_HOUDINI_HOME_VEX_PATH="${COMMON_HOUDINI_HOME}/${__VEX_STR__}"
    COMMON_HOUDINI_HOME_UI_ICON_PATH="${COMMON_HOUDINI_HOME}/${__CONFIG_STR__}/${__ICONS_STR__}"
    COMMON_HOUDINI_HOME_ASSET_STORE_PATH="${COMMON_HOUDINI_HOME}/${__ASSETSTORE_STR__}"
    COMMON_HOUDINI_HOME_USER_PREF_DIR_PATH="${COMMON_HOUDINI_HOME}"
}


function _CommonHomeEnvironment()
{
    COMMON_DIR="${FXHOME}/${COMMON}"
    COMMON_HOME="${COMMON_DIR}/HOME"
    COMMON_HOME_SCRIPTS_PATH="${COMMON_HOME}/${__SCRIPTS_STR__}"
    COMMON_HOME_SCRIPTS_PYTHON_PATH="${COMMON_HOME_SCRIPTS_PATH}/${__PYTHON_STR__}"
    COMMON_HOME_OTL_PATH="${COMMON_HOME}/${__OTLS_STR__}"
    COMMON_HOME_TOOLBAR_PATH="${COMMON_HOME}/${__TOOLBAR_STR__}"
    COMMON_HOME_DSO_PATH="${COMMON_HOME}/${__DSO_STR__}"
    COMMON_HOME_PYTHON_PANEL_PATH="${COMMON_HOME}/${__PYTHONPANELS_STR__}"
    COMMON_HOME_VEX_PATH="${COMMON_HOME}/${__VEX_STR__}"
    COMMON_HOME_UI_ICON_PATH="${COMMON_HOME}/${__CONFIG_STR__}/${__ICONS_STR__}"
    COMMON_HOME_ASSET_STORE_PATH="${COMMON_HOME}/${__ASSETSTORE_STR__}"
    COMMON_HOME_USER_PREF_DIR_PATH="${COMMON_HOME}"
}


function _CommonUSDEnvironment()
{
    _ConstantString
    local _usd_dirname="USD"
    COMMON_DIR="${FXHOME}/${COMMON}"
    COMMON_USD_DIRPATH="${COMMON_DIR}/${_usd_dirname}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
}


function _SystemEnvironment()
{
    local MAGICSTR=";&;"
    _PersonEnvironment
    _CommonHoudiniHomeEnvironment
    _CommonHomeEnvironment
    _CommonUSDEnvironment
    export HOUDINI_MAX_FILE_HISTORY=30
    export HISTSIZE=10000
    export HOUDINI_USE_HFS_PYTHON=0
    export HOUDINI_BUFFEREDSAVE=1
    export HOUDINI_NO_SPLASH=0
    export HOUDINI_NO_START_PAGE_SPLASH=1
    export HOUDINI_UISCALE=200
    export VISUAL="/snap/bin/code -w -n"
    # (2019.04.17): ocio 환경변수 추가
#    export OCIO="/home/method/nukesetting/assets/cache_data/ocio/sfm/config.ocio"
    # OpenCL setting
    # opencl을 사용 할 GPU 디바이스 넘버 (gpu가 여러개인 경우를 대비하여...)
#    export HOUDINI_OCL_DEVICENUMBER=0
#    # houdini18.0 이상이면, 아래의 셋팅 적용.
#    if [[ ${MAJOR_VERSION} -ge 18 ]];then
#        # jemalloc 라이브러리
#        local JEMALLOC_SHELL_FILE="/usr/bin/jemalloc.sh"
#        if [[ -f "${JEMALLOC_SHELL_FILE}" ]];then
#            source "${JEMALLOC_SHELL_FILE}"
#            if [[ $? == 0 ]];then
#                echo
#                echo "JEMalloc으로 변경되었습니다."
#                echo
#            else
#                echo
#                echo -e '\e[3;31m' "[Warning] JEMalloc으로 변경 실패하였습니다."
#                echo
#            fi
#        else
#            echo
#            echo -e '\e[3;31m' "[Warning] JEMalloc 라이브러리가 설치되어 있지 않습니다."
#            echo
#        fi
#        # jemalloc 테스트 활성화
#        export HOUDINI_DISABLE_JEMALLOCTEST=0
#
#        # NVIDIA optiX setting
#        local OPTIX_DIRPATH="/home/method/libs/optixlibs-5.1-linux-x86_64"
#        # 만약 optix 디렉토리가 존재한다면...
#        if [[ -d "${OPTIX_DIRPATH}" ]];then
#            # optix를 사용 할 GPU 디바이스 넘버. (gpu가 여러개인 경우를 대비하여...)
#            export HOUDINI_NVIDIA_OPTIX_DEVICENUMBER=0
#            export HOUDINI_NVIDIA_OPTIX_DSO_PATH="${OPTIX_DIRPATH}"
#        else
#            echo
#            echo -e '\e[3;31m' "[Warning] NVIDIA OptiX 디렉토리가 존재하지 않습니다."
#            echo -e '\e[3;31m' "설치되어 있는 지 확인해주십시오."
#            echo
#        fi
#    fi
#    #############################################################################################
#    # houdini 17 버전에서만 레드쉬프트 적용.
#    if [[ ${MAJOR_VERSION} == 17 ]];then
#        #############################################################################################
#        # RED SHIFT
#        # ------------------------------------------------------------------------------------------
#        local _REDSHIFT_FLAG=0
#        for _UNAME in user1 user2 user3 user4 user5;do
#            if [[ "${FXUSER}" == "${_UNAME}" ]];then
#                _REDSHIFT_FLAG=1
#                break
#            fi
#        done
#
#        if [[ ${_REDSHIFT_FLAG} == 1 ]];then
#            export redshift_LICENSE=5053@000.000.000.000
#        else
#            export redshift_LICENSE=5053@000.000.000.000
#        fi
#        # ------------------------------------------------------------------------------------------
#        export HOUDINI_DSO_ERROR=2
#        #############################################################################################
#        # ####################### RED SHIFT PATH ############################
#        export PATH="${PERSONAL_REDSHIFT_PATH}:${PATH}"
#        export HOUDINI_PATH="${PERSONAL_REDSHIFT_HOUDINI_PATH}:${COMMON_HOME}:${COMMON_HOUDINI_HOME}:${HOUDINI_USER_HOME}${MAGICSTR}"
#        export HOUDINI_DSO_PATH="${PERSONAL_REDSHIFT_HOUDINI_DSO_PATH}:${COMMON_HOME_DSO_PATH}:${COMMON_HOUDINI_HOME_DSO_PATH}:${PERSONAL_DSO_PATH}:@/${__DSO_STR__}${MAGICSTR}"
#    else
#        export HOUDINI_PATH="${COMMON_HOME}:${COMMON_HOUDINI_HOME}:${COMMON_USD_DIRPATH}:${HOUDINI_USER_HOME}${MAGICSTR}"
#    	export HOUDINI_DSO_PATH="${COMMON_HOME_DSO_PATH}:${COMMON_HOUDINI_HOME_DSO_PATH}:${PERSONAL_DSO_PATH}:@/${__DSO_STR__}${MAGICSTR}"
#    fi

    #############################################################################################
    #
    export HOUDINI_OTLSCAN_PATH="${COMMON_HOME_OTL_PATH}:${COMMON_HOUDINI_HOME_OTL_PATH}:${PERSONAL_OTL_PATH}:@/${__OTLS_STR__}${MAGICSTR}"
    #
    export HOUDINI_SCRIPT_PATH="${COMMON_HOUDINI_HOME_SCRIPTS_PATH}:${COMMON_HOME_SCRIPTS_PATH}:${PERSONAL_SCRIPTS_PATH}:@/${__SCRIPTS_STR__}${MAGICSTR}"
    #
    export HOUDINI_ASSET_STORE_PATH="${COMMON_HOUDINI_HOME_ASSET_STORE_PATH}"
    #

    ################ each user toolbar path #########################
    #local EACHUSERTOOLBARPATH=$(python "${FXSCRIPT_FULL_MODULES_ENV_DIR}/SCZ_MakeEachPath.py" "${MAJOR_VERSION}.${MINOR_VERSION}" "${FXHOMEUSER}" "toolbar")
    #export HOUDINI_TOOLBAR_PATH="${EACHUSERTOOLBARPATH}:${COMMON_TOOLBAR_PATH}${MAGICSTR}"
    export HOUDINI_TOOLBAR_PATH="${COMMON_HOME_TOOLBAR_PATH}:${COMMON_HOUDINI_HOME_TOOLBAR_PATH}:${PERSONAL_TOOLBAR_PATH}:@/${__TOOLBAR_STR__}${MAGICSTR}"
    #
    #################################################################
    # REVERSE
    export HOUDINI_PYTHON_PANEL_PATH="${COMMON_HOME_PYTHON_PANEL_PATH}:${COMMON_HOUDINI_HOME_PYTHON_PANEL_PATH}:${PERSONAL_PYTHON_PANEL_PATH}:@/${__PYTHONPANELS_STR__}${MAGICSTR}"
    #
    # REVERSE
    export HOUDINI_UI_ICON_PATH="${COMMON_HOME_UI_ICON_PATH}:${COMMON_HOUDINI_HOME_UI_ICON_PATH}:${PERSONAL_UI_ICON_PATH}:@/${__CONFIG_STR__}/${__ICONS_STR__}${MAGICSTR}"
    #
    # REVERSE
    export HOUDINI_VEX_PATH="${COMMON_HOME_VEX_PATH}:${COMMON_HOUDINI_HOME_VEX_PATH}:${PERSONAL_VEX_PATH}:@/${__VEX_STR__}${MAGICSTR}"
    #
    export HOUDINI_USER_PREF_DIR="${PERSONAL_USER_PREF_DIR_PATH}"
    #export HOUDINI_TEMP_PATH="${FXHOMEUSER}/${FXUSER}"
    #export HOUDINI_TEMP_DIR="${FXHOMEUSER}/${FXUSER}"
    export HOUDINI_TEMP_DIR="/tmp"
    # in houdini
    export __USERNAME__=${FXUSER}
    export __USERSDIR__=${FXHOMEUSER}
    # history
    export __NO_HISTORY__=${NO_HISTORY}
    # fx database
    export __NO_SQL__=${NO_SQL}
    # HQueue Variables
    export HQROOT="/mnt/hq"
    export HQCLIENTARCH="linux-x86_64"
    #############################################################################################
    # 2018.06.25
    ######### QT5 ##########
    #SW_ROOT="/home/method/softwares"
    #QT5_ROOT="${SW_ROOT}/qt5.6.2"
    #USER_LIB="${QT5_ROOT}/lib"
    ########################
    #[[ ":$PATH:" != *":${QT5_ROOT}/bin:"* ]] && PATH="${QT5_ROOT}/bin:${PATH}"
    #[[ ":$LD_LIBRARY_PATH:" != *":${USER_LIB}:"* ]] && LD_LIBRARY_PATH="${USER_LIB}:${LD_LIBRARY_PATH}"
    ###### Qt Designer #####
    #[[ ":$QT_PLUGIN_PATH:" != *":${QT5_ROOT}/plugins:"* ]] && QT_PLUGIN_PATH="${QT_PLUGIN_PATH}:${QT5_ROOT}/plugins"
    ########################
    #export PATH LD_LIBRARY_PATH QT_PLUGIN_PATH
    #export QTDIR="/home/method/softwares/qt5.6.2"
    #export QTINC="${QTDIR}/include"
    #export QTLIB="${QTDIR}/lib"
    ##############################################################################################
}


function _ShowVars()
{
    echo
    echo "--------------------------------------------------------------"
    echo "Custom Environment Variables."
    echo
    echo "***** Machine Information *****"
    echo "HOSTNAME : ""${HOSTNAME}"
    echo "LOGNAME : ""${LOGNAME}"
    echo "UID : ""${UID}"
    #echo "IP : ""$(ifconfig | head -2 | awk -F' ' '{print $2}' | awk -F'addr:' '{print $2}' | tail -1)"
    echo "IP : ""$(ifconfig | head -2 | awk -F'inet' '{print $2}' | awk -F' ' '{print $1}' | tail -1)"
    echo
    echo "***** Variables Information *****"
    echo "FXUSER : ""${FXUSER}"
    echo "FXHOMEUSER : ""${FXHOMEUSER}"
    echo "__HOUDINI_VERSION__ : ""${__HOUDINI_VERSION__}"
    echo "Houdini Install Dir : ""/${DEF_OPT_DIR}/${DEF_HOU_BRG}${__HOUDINI_VERSION__}"
    echo "HISTSIZE : ""${HISTSIZE}"
    echo "HOUDINI_USE_HFS_PYTHON : ""${HOUDINI_USE_HFS_PYTHON}"
    echo "HOUDINI_BUFFEREDSAVE : ""${HOUDINI_BUFFEREDSAVE}"
    echo "HOUDINI_PATH : ""${HOUDINI_PATH}"
    echo "HOUDINI_DSO_PATH : ""${HOUDINI_DSO_PATH}"
    echo "HOUDINI_OTLSCAN_PATH : ""${HOUDINI_OTLSCAN_PATH}"
    echo "HOUDINI_SCRIPT_PATH : ""${HOUDINI_SCRIPT_PATH}"
    echo "HOUDINI_TOOLBAR_PATH : ""${HOUDINI_TOOLBAR_PATH}"
    echo "HOUDINI_PYTHON_PANEL_PATH : ""${HOUDINI_PYTHON_PANEL_PATH}"
    echo "HOUDINI_UI_ICON_PATH : ""${HOUDINI_UI_ICON_PATH}"
    echo "HOUDINI_VEX_PATH : ""${HOUDINI_VEX_PATH}"
    echo "HOUDINI_USER_PREF_DIR : ""${HOUDINI_USER_PREF_DIR}"
    echo "HOUDINI_TEMP_DIR : ""${HOUDINI_TEMP_DIR}"
    echo "HIH : ""${HIH}"
    echo "USER : ""${USER}"
    echo "NO_HISTORY : ""${NO_HISTORY}"
    echo "NO_SQL : ""${NO_SQL}"
    echo "--------------------------------------------------------------"
    echo "PATH : ""${PATH}"
    echo "PYTHONPATH : ""${PYTHONPATH}"
    echo "LD_LIBRARY_PATH : ""${LD_LIBRARY_PATH}"
    echo "--------------------------------------------------------------"
    echo "QTDIR : ""${QTDIR}"
    echo "QTINC : ""${QTINC}"
    echo "QTLIB : ""${QTLIB}"
    echo "QT_PLUGIN_PATH : ""${QT_PLUGIN_PATH}"
    echo "--------------------------------------------------------------"
    echo "HQROOT : ""${HQROOT}"
    echo "HQCLIENTARCH : ""${HQCLIENTARCH}"
    echo "--------------------------------------------------------------"
    echo
}


function _ShowVarsColor()
{
    echo
    echo "--------------------------------------------------------------"
    echo "Custom Environment Variables."
    echo
    echo "***** Machine Information *****"
    echo -e '\e[0;33m' "HOSTNAME : " '\e[0;32m' "${HOSTNAME}"
    echo -e '\e[0;33m' "LOGNAME : " '\e[0;32m' "${LOGNAME}"
    echo -e '\e[0;33m' "UID : " '\e[0;32m' "${UID}"
    #echo -e '\e[0;33m' "IP : " '\e[0;32m' "$(ifconfig | head -2 | awk -F' ' '{print $2}' | awk -F'addr:' '{print $2}' | tail -1)"
    echo -e '\e[0;33m'  "IP : " '\e[0;32m' "$(ifconfig | head -2 | awk -F'inet' '{print $2}' | awk -F' ' '{print $1}' | tail -1)"
    echo
    tput sgr0
    echo "***** Variables Information *****"
    echo -e '\e[0;33m' "FXUSER : " '\e[0;32m' "${FXUSER}"
    echo -e '\e[0;33m' "FXHOMEUSER : " '\e[0;32m' "${FXHOMEUSER}"
    echo -e '\e[0;33m' "__HOUDINI_VERSION__ : " '\e[0;32m' "${__HOUDINI_VERSION__}"
    echo -e '\e[0;33m' "Houdini Install Dir : " '\e[0;32m' "/${DEF_OPT_DIR}/${DEF_HOU_BRG}${__HOUDINI_VERSION__}"
    echo -e '\e[0;33m' "HISTSIZE : " '\e[0;32m' "${HISTSIZE}"
    echo -e '\e[0;33m' "HOUDINI_USE_HFS_PYTHON : " '\e[0;32m' "${HOUDINI_USE_HFS_PYTHON}"
    echo -e '\e[0;33m' "HOUDINI_BUFFEREDSAVE : " '\e[0;32m' "${HOUDINI_BUFFEREDSAVE}"
    echo -e '\e[0;33m' "HOUDINI_PATH : " '\e[0;32m' "${HOUDINI_PATH}"
    echo -e '\e[0;33m' "HOUDINI_DSO_PATH : " '\e[0;32m' "${HOUDINI_DSO_PATH}"
    echo -e '\e[0;33m' "HOUDINI_OTLSCAN_PATH : " '\e[0;32m' "${HOUDINI_OTLSCAN_PATH}"
    echo -e '\e[0;33m' "HOUDINI_SCRIPT_PATH : " '\e[0;32m' "${HOUDINI_SCRIPT_PATH}"
    echo -e '\e[0;33m' "HOUDINI_TOOLBAR_PATH : " '\e[0;32m' "${HOUDINI_TOOLBAR_PATH}"
    echo -e '\e[0;33m' "HOUDINI_PYTHON_PANEL_PATH : " '\e[0;32m' "${HOUDINI_PYTHON_PANEL_PATH}"
    echo -e '\e[0;33m' "HOUDINI_UI_ICON_PATH : " '\e[0;32m' "${HOUDINI_UI_ICON_PATH}"
    echo -e '\e[0;33m' "HOUDINI_VEX_PATH : " '\e[0;32m' "${HOUDINI_VEX_PATH}"
    echo -e '\e[0;33m' "HOUDINI_ASSET_STORE_PATH : " '\e[0;32m' "${HOUDINI_ASSET_STORE_PATH}"
    echo -e '\e[0;33m' "HOUDINI_USER_PREF_DIR : " '\e[0;32m' "${HOUDINI_USER_PREF_DIR}"
    echo -e '\e[0;33m' "HOUDINI_TEMP_DIR : " '\e[0;32m' "${HOUDINI_TEMP_DIR}"
    echo -e '\e[0;33m' "HIH : " '\e[0;32m' "${HIH}"
    echo -e '\e[0;33m' "USER : " '\e[0;32m' "${USER}"
    echo -e '\e[0;33m' "NO_HISTORY : " '\e[0;32m' "${NO_HISTORY}"
    echo -e '\e[0;33m' "NO_SQL : " '\e[0;32m' "${NO_SQL}"
    echo "--------------------------------------------------------------"
    echo -e '\e[0;33m' "PATH : " '\e[0;32m' "${PATH}"
    echo -e '\e[0;33m' "PYTHONPATH : " '\e[0;32m' "${PYTHONPATH}"
    echo -e '\e[0;33m' "LD_LIBRARY_PATH : " '\e[0;32m' "${LD_LIBRARY_PATH}"
    echo "--------------------------------------------------------------"
    echo -e '\e[0;33m' "QTDIR : " '\e[0;32m' "${QTDIR}"
    echo -e '\e[0;33m' "QTINC : " '\e[0;32m' "${QTINC}"
    echo -e '\e[0;33m' "QTLIB : " '\e[0;32m' "${QTLIB}"
    echo -e '\e[0;33m' "QT_PLUGIN_PATH : " '\e[0;32m' "${QT_PLUGIN_PATH}"
    echo "--------------------------------------------------------------"
    echo -e '\e[0;33m' "HQROOT : " '\e[0;32m' "${HQROOT}"
    echo -e '\e[0;33m' "HQCLIENTARCH : " '\e[0;32m' "${HQCLIENTARCH}"
    echo "--------------------------------------------------------------"
    tput sgr0
    echo
}


function _MakeDirs()
{
    _ConstantString
    _MakeDirectory "${FXHOMEUSER}/${FXUSER}"
    local _fxuser_houpath="${FXHOMEUSER}/${FXUSER}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    _MakeDirectory "${_fxuser_houpath}/dso"
    _MakeDirectory "${_fxuser_houpath}/otls"
    _MakeDirectory "${_fxuser_houpath}/vex"
    _MakeDirectory "${_fxuser_houpath}/scripts/python"
    echo -n
    local _fx_commonpath="${FXHOME}/${COMMON}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    _MakeDirectory "${_fx_commonpath}"
    _MakeDirectory "${_fx_commonpath}/config/Icons"
    _MakeDirectory "${_fx_commonpath}/dso"
    _MakeDirectory "${_fx_commonpath}/otls"
    _MakeDirectory "${_fx_commonpath}/vex"
    _MakeDirectory "${_fx_commonpath}/python"
    _MakeDirectory "${_fx_commonpath}/python_panels"
    _MakeDirectory "${_fx_commonpath}/scripts/python"
    _MakeDirectory "${_fx_commonpath}/toolbar"
    echo -n
}


function _MakeFiles()
{
    _ConstantString
    local _fxuser_houpath="${FXHOMEUSER}/${FXUSER}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    _MakeFile "${_fxuser_houpath}/scripts/123_user.cmd"
    _MakeFile "${_fxuser_houpath}/scripts/456_user.cmd"
    echo -n
    local _fx_commonpath="${FXHOME}/${COMMON}/${__HOUDINI_STR__}${MAJOR_VERSION}.${MINOR_VERSION}"
    _MakeFile "${_fx_commonpath}/scripts/123.cmd"
    _MakeFile "${_fx_commonpath}/scripts/456.cmd"
    _MakeFile "${_fx_commonpath}/scripts/123.py"
    _MakeFile "${_fx_commonpath}/scripts/456.py"
    echo -n
}


function _Main()
{
    _MakeDirs
    #_MakeFiles
    _SystemEnvironment

    echo
    echo "${FXUSER}'s Houdini Home Directory: ${HOUDINI_USER_HOME}"
}


function _HoudiniSourcing()
{
    local __HOUDINI_INSTALL_PATH__="/${DEF_OPT_DIR}/${DEF_HOU_BRG}${__HOUDINI_VERSION__}"
    cd ${__HOUDINI_INSTALL_PATH__}
    echo "====================================================="
    echo `pwd`
    source houdini_setup_bash
    echo "====================================================="
    #################################
    #echo "ENV FILE, python path: ${PYTHONPATH}"
    #################################
    cd - > /dev/null
    export HIH=${HOUDINI_USER_HOME}
    export USER="${FXUSER}" 		# create temporary hip file for crash houdini.
    if [[ "$FXSHOW" == "1" ]];then
        _ShowVars
        #_ShowVarsColor
    else
        :
    fi
}


_Main
_HoudiniSourcing




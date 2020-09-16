#!/usr/bin/env bash

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

######################### UnSet Variables #########################

if [[ "$1" == "run" ]];then
    echo -e '\e[0;33m'"Run Unset Variables..."
    tput sgr0
    unset DEF_OPT_DIR DEF_HOU_BRG
    unset FXSCRIPT_FULL_HRENDER_DIR
elif [[ "$1" == "render" ]];then
    echo "Render Unset Variables..."
else
    :
fi
###################################################################

unset DEF_HOUDINI_VERSION DEF_FXUSER DEF_FXHOME DEF_FXHOME_USER_BRIDGE_DIR DEF_FXHOME_COMMON_BRIDGE_DIR
unset FXSCRIPT FXSCRIPT_ROOT FXSCRIPT_FULL_DIR HRUN_DIR HVERSION FXHOME_DIR
unset FXSCRIPT_FULL_MODULES_DIR FXSCRIPT_FULL_MODULES_ENV_DIR FXSCRIPT_FULL_MODULES_DEF_DIR FXSCRIPT_FULL_HRUN_DIR FXSCRIPT_FULL_HRUN_ARGS_DIR
unset FXSCRIPT_FULL_HRENDER_ARGS_DIR FXSCRIPT_FULL_HRENDER_SETPARM_DIR

# hrender.sh 쉘 파일 변경으로 인한 주석처리. 명령어를 hython으로 바꾸면서 필요한 변수이다.
#unset FXSCRIPT_FULL_HRENDER_DIR

unset BASE_DIR

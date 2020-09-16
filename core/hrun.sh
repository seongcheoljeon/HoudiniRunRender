#!/bin/bash -

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

THIS_FILE_PATH=`echo "$0" | awk -F' ' '{print $1}'`
THIS_FILE_NAME=`basename ${THIS_FILE_PATH}`

echo "=========================================="
echo "SCRIPT VERSION : ${SCRIPT_VERSION}"
echo "SCRIPT FILENAME : ${THIS_FILE_NAME}"
echo "=========================================="
echo

RUN_SCRIPT_FILE="hrun.sh"

SCRIPTDIR="${BASE_DIR}/${HRUN_DIR}"

source "${SCRIPTDIR}/init.sh"

source "${FXSCRIPT_FULL_HRUN_DIR}/${RUN_SCRIPT_FILE}" $*

cd $HOME


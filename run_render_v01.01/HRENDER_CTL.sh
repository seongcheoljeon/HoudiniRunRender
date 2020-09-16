#!/bin/bash -

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

#/opt/hfs16.0.671/bin/hserver
#/opt/hfs16.0.671/bin/hserver -S 172.25.4.205

RRINITFILE="/media/scii/2TB/pipeline/houdini/scripts/shell/hrr.init"
source ${RRINITFILE}

source "/media/scii/2TB/pipeline/houdini/scripts/shell/run_render_${INIT__RR_VERSION}/VERSION_CTL.sh"

SCRIPT_VERSION="${INIT__SCRIPT_VERSION}"
HVERSION="${INIT__HVERSION}"

BASE_DIR="${INIT__BASE_DIR}"
HRUN_DIR="${INIT__HRUN_DIR}"
HRUN_FILE="hrender.sh"

FXHOME_DIR="${INIT__FXHOME_DIR}"

export SCRIPT_VERSION HVERSION BASE_DIR HRUN_DIR FXHOME_DIR
unset INIT__SCRIPT_VERSION INIT__HVERSION INIT__BASE_DIR INIT__HRUN_DIR INIT__FXHOME_DIR INIT__RR_VERSION

${BASE_DIR}/${HRUN_DIR}/${HRUN_FILE} $*





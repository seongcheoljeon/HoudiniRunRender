#!/bin/bash -

# created date: 2020.09.16
# author: seongcheol jeon
# email: saelly55@gmail.com

#set -o nounset                              # Treat unset variables as an error

PARENT_DIR="/media/scii/2TB/pipeline/houdini/scripts/houdini_run_render"

RRINITFILE="${PARENT_DIR}/hrr.init"
source ${RRINITFILE}

source "${PARENT_DIR}/run_render_${INIT__RR_VERSION}/VERSION_CTL.sh"

SCRIPT_VERSION="${INIT__SCRIPT_VERSION}"
HVERSION="${INIT__HVERSION}"

BASE_DIR="${INIT__BASE_DIR}"
HRUN_DIR="${INIT__HRUN_DIR}"
HRUN_FILE="hrun.sh"
HRUN_OPT="-n"

FXHOME_DIR="${INIT__FXHOME_DIR}"

export SCRIPT_VERSION HVERSION BASE_DIR HRUN_DIR FXHOME_DIR
unset INIT__SCRIPT_VERSION INIT__HVERSION INIT__BASE_DIR INIT__HRUN_DIR INIT__FXHOME_DIR INIT__RR_VERSION PARENT_DIR

source ${BASE_DIR}/${HRUN_DIR}/${HRUN_FILE} ${HRUN_OPT} $*





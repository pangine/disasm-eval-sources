#!/bin/bash

# The prefix commands that linux build processes share in common, including:
#   encode OPTIONS for directory name
#   create output folders
#   cd into the project
# This script should be called using `source` to inherit env arguments.

cd ${HOME}
OPTIONS=${1:-""}
if [ -z $OPTIONS ]
then
  OPTIONS_FOLDER=default
else
  OPTIONS_FOLDER=`echo $OPTIONS | ${LINUX_SCRIPTS_DIR}/file_name_escape.awk`
fi

OUTPUT_DIR=${2:-${HOME}/output}

OPTIONS_DIR=${HOME}/${COMPILER_TAG}/${OPTIONS_FOLDER}
BIN_DIR=${OPTIONS_DIR}/bin
BUILD_DIR=${OPTIONS_DIR}/build
mkdir -p ${BIN_DIR}/${PKG} ${BUILD_DIR}
cd ${HOME}/${PKG}

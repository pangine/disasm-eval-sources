#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Build
mkdir build
cd build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
cmake -DCMAKE_INSTALL_PREFIX=${HOME}/local -DCMAKE_C_FLAGS="${OPTIONS} -m32 --save-temps -g -Wno-error" ./..
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

cp cstool ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

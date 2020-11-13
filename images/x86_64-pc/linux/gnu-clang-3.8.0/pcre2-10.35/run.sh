#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Build
mkdir build
cd build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
../configure --prefix=${HOME}/local CFLAGS="${OPTIONS} --save-temps -g -Wno-error"
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp .libs/pcre2grep ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

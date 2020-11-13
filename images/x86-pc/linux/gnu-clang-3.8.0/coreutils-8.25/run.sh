#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

mkdir build
cd ${HOME}/${PKG}/build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
LIBS="-L/usr/lib/clang/3.8.0/lib/linux -lclang_rt.builtins-i386" \
../configure --prefix=${HOME}/local CFLAGS="${OPTIONS} -m32 --save-temps -g -Wno-error"
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make install
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Move files to result directories
mv ${HOME}/local/bin/* ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

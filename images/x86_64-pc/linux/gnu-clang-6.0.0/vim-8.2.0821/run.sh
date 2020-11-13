#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
LIBS="-L/usr/lib/clang/6.0.0/lib/linux -lclang_rt.builtins-x86_64" \
./configure --prefix=${HOME}/local CFLAGS="${OPTIONS} --save-temps -g -Wno-error"
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp src/vim ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

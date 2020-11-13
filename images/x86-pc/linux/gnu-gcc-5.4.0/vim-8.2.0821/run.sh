#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
./configure --prefix=${HOME}/local CFLAGS="${OPTIONS} -m32 --save-temps -g -Wno-error" LDFLAGS="-m32 -L/usr/lib/i386-linux-gnu"
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp src/vim ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

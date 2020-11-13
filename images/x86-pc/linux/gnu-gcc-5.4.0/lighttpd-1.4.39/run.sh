#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

mkdir build
cd ${HOME}/${PKG}/build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
../configure --prefix=${HOME}/local CFLAGS="${OPTIONS} -m32 --save-temps -g -Wno-error" LDFLAGS="-m32" --without-zlib --without-bzip2 --without-pcre
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make install
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Move files to result directories
mv ${HOME}/local/sbin/* ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

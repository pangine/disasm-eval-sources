#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

${LINUX_SCRIPTS_DIR}/git_prepare.sh
./configure --prefix=${HOME}/local --with-cc-opt="${OPTIONS} -m32 --save-temps -g -Wno-error" --with-ld-opt="-m32" --without-http_gzip_module --without-http_rewrite_module
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make install
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Move files to result directories
mv ${HOME}/local/sbin/* ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

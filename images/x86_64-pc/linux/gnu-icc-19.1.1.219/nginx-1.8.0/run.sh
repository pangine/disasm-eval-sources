#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Rename "opt_report_file" argument with "qopt_report_file"
sed -i "s~-opt_report_file=~-qopt_report_file=~g" auto/cc/icc

${LINUX_SCRIPTS_DIR}/git_prepare.sh
./configure --prefix=${HOME}/local --with-cc-opt="${OPTIONS} --save-temps -g -Wno-error" --without-http_gzip_module --without-http_rewrite_module
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make install
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Move files to result directories
mv ${HOME}/local/sbin/* ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

MIT_LSP_FILE=bzip2
${LINUX_SCRIPTS_DIR}/git_prepare.sh
${CC} ${MIT_LSP_FILE}.c ${OPTIONS} --save-temps -g -Wno-error -lm -o ${MIT_LSP_FILE}
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp ${MIT_LSP_FILE} ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

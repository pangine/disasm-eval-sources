#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

${LINUX_SCRIPTS_DIR}/git_prepare.sh
${CC} shell.c sqlite3.c ${OPTIONS} -m32 --save-temps -g -Wno-error -lpthread -ldl -o sqlite3
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp sqlite3 ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

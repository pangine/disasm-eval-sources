#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

${LINUX_SCRIPTS_DIR}/git_prepare.sh
${CC} ${OPTIONS} /FAcs /Z7 bzip2.c /Febzip2.exe /link /DEBUG:FULL /MAP
dumpbin.exe /RAWDATA:NONE /ALL o/bzip2.exe > bzip2.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp bzip2.exe ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

${LINUX_SCRIPTS_DIR}/git_prepare.sh
${CC} ${OPTIONS} /FAcs /Z7 shell.c sqlite3.c /Fesqlite3.exe /link /DEBUG:FULL /MAP
dumpbin.exe /RAWDATA:NONE /ALL o/sqlite3.exe > sqlite3.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp sqlite3.exe ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

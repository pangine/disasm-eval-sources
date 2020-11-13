#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

cd ${HOME}/${PKG}/windows
# Modify nmake file to out debug files
sed -i "s~^CFLAGS = /nologo /W3 /O1 -I..~CFLAGS = /FAcs /Z7 /nologo /W3 ${OPTIONS//\\/\\\\} -I..~g" Makefile.vc
sed -i "s~^LFLAGS = /incremental:no~LFLAGS = /DEBUG:FULL /MAP /incremental:no~g"  Makefile.vc

${LINUX_SCRIPTS_DIR}/git_prepare.sh
nmake /f Makefile.vc
dumpbin.exe /RAWDATA:NONE /ALL putty.exe > putty.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp putty.exe ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv windows ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

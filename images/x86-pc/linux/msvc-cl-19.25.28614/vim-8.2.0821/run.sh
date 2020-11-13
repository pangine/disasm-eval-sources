#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

cd ${HOME}/${PKG}/src
# Modify nmake file to out debug files
# Use unsalted cl compiler for checking compiler version
sed -i "s~\$(CC) /EP~z:\\\opt\\\msvc\\\vc\\\tools\\\msvc\\\14.26.28801\\\bin\\\Hostx64\\\x86\\\cl.exe /EP~g" Make_mvc.mak
# CFLAGS
sed -i "s~^CFLAGS = \$(CFLAGS) \$(OPTFLAG)~CFLAGS = \$(CFLAGS) /FAcs ${OPTIONS//\\/\\\\}~g ; s~^DEBUGINFO = /Zi~DEBUGINFO = /Z7~g" Make_mvc.mak
# Remove LTO (/GL & /LTCG:STATUS)
sed -i "s~^OPTFLAG = $(OPTFLAG) /GL~OPTFLAG = $(OPTFLAG)~g ; s~LINKARGS1 = $(LINKARGS1) /LTCG:STATUS~LINKARGS1 = $(LINKARGS1)~g" Make_mvc.mak

${LINUX_SCRIPTS_DIR}/git_prepare.sh
nmake /f Make_mvc.mak CPU=I386 MAP=yes USE_MP=no
dumpbin.exe /RAWDATA:NONE /ALL vim.exe > vim.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp vim.exe ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv src ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

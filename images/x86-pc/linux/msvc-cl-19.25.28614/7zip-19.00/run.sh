#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

cd ${HOME}/${PKG}/CPP
sed -i "s~link \$(LFLAGS) -out:\$(PROGPATH) \$(OBJS) \$(LIBS)~link \$(LFLAGS) -out:\$(PROGPATH) @<< \n\$(OBJS) \$(LIBS)\n<<~g" Build.mak
# Remove original optimization levels
sed -i "s~ -O1~~g ; s~ -O2~~g" Build.mak

cd ${HOME}/${PKG}/C/Util/7z
sed -i "s~^CFLAGS = \$(CFLAGS) -D_7ZIP_PPMD_SUPPPORT~CFLAGS = \$(CFLAGS) ${OPTIONS//\\/\\\\} /FAcs /Z7 -D_7ZIP_PPMD_SUPPPORT\nLFLAGS = /DEBUG:FULL /MAP~g" makefile

${LINUX_SCRIPTS_DIR}/git_prepare.sh
nmake
dumpbin.exe /RAWDATA:NONE /ALL o/7zDec.exe > 7zDec.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp o/7zDec.exe ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}/C/Util
mv 7z ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

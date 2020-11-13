#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Build
mkdir build
cd build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
cmake -DCMAKE_BUILD_TYPE=DEBUG -DCMAKE_C_FLAGS_DEBUG="${OPTIONS} /FAcs /Z7" -DCMAKE_EXE_LINKER_FLAGS_INIT="/DEBUG:FULL /MAP" ./..
${LINUX_SCRIPTS_DIR}/git_prepare.sh
nmake
dumpbin.exe /RAWDATA:NONE /ALL cstool.exe > cstool.dumpbin.out
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp cstool.exe ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

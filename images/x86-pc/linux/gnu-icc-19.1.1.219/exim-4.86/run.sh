#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Config the build
cp exim_monitor/EDITME Local/eximon.conf
cp src/EDITME Local/Makefile
sed -i "s~^EXIM_USER=~EXIM_USER=$(whoami)~g" Local/Makefile
echo "CC=${LINUX_SCRIPTS_DIR}/gt_cc.sh" >> Local/Makefile

# Build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make build=Linux CFLAGS="${OPTIONS} -m32 --save-temps -g -Wno-error" LFLAGS="-m32 -L/usr/lib/i386-linux-gnu"
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp build-Linux/exim ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

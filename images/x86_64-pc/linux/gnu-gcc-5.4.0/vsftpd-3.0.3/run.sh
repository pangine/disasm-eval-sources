#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

# Config the make
sed -i "s~^CC \t=\tgcc~CC \t=\t${CC}~g" Makefile
sed -i "s~^LINK\t=\t-Wl,-s~LINK\t=~g" Makefile
sed -i "s~^CFLAGS\t=\t-O2~CFLAGS\t=\t${OPTIONS} --save-temps -g~g ; s~-Werror~-Wno-error~g" Makefile

${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
cp vsftpd ${BIN_DIR}/${PKG}
cd ${HOME}
mv ${PKG} ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

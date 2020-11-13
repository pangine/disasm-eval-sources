#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh

mkdir build
cd ${HOME}/${PKG}/build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
LIBS="-L/usr/lib/clang/3.8.0/lib/linux -lclang_rt.builtins-x86_64" \
../configure --prefix=${HOME}/local CFLAGS="${OPTIONS} --save-temps -g -Wno-error"
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make
${LINUX_SCRIPTS_DIR}/git_finish.sh

# Copy files to result directories
# Because openssh `make install` require root privilege regardless the
# install directory, we need manually copy the binaries instead of using `make install`
declare -a BINARIES=("scp" "sftp" "ssh" "ssh-add" "ssh-agent" "ssh-keygen" "ssh-keyscan" "sshd")
for BIN in ${BINARIES[@]}
do
  cp ${BIN} ${BIN_DIR}/${PKG}
done
cd ${HOME}/${PKG}
mv build ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

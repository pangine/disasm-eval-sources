#!/bin/bash

source ${LINUX_SCRIPTS_DIR}/run_prefix.sh
# Config the build
cd C/Util/7z
# CFLAGS
sed -i "s~^CXX = gcc~CXX=${CC}~g ; s~^CFLAGS = -c -O2 -Wall~CFLAGS = -c ${OPTIONS} -m32 --save-temps -g -Wno-error~g" makefile.gcc
# LDFLAGS
sed -i "s~^LIB =~LIB =\nLDFLAGS= -m32~g" makefile.gcc
# clang compiler-rt lib
sed -i "s~^LIB =~LIB = -L/usr/lib/clang/3.8.0/lib/linux -lclang_rt.builtins-i386~g" makefile.gcc

# Build
${LINUX_SCRIPTS_DIR}/git_prepare.sh
make -f makefile.gcc
${LINUX_SCRIPTS_DIR}/git_finish.sh

cp 7zDec ${BIN_DIR}/${PKG}
cd ${HOME}/${PKG}/C/Util
mv 7z ${BUILD_DIR}/${PKG}

source ${LINUX_SCRIPTS_DIR}/run_suffix.sh

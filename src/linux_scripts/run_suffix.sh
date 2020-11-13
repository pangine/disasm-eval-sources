#!/bin/bash

# The suffix commands that linux build processes share in common, including:
#   zip the result directory into tgz file
# This script should be called using `source` to inherit env arguments.

cd ${HOME}
TARNAME=${COMPILER_TAG}-${PKG}-${OPTIONS_FOLDER}.tar.xz
tar cf - ${COMPILER_TAG} | xz -9 -c - > ${OUTPUT_DIR}/${TARNAME}

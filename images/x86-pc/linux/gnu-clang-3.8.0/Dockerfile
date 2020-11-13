ARG DISTRO
# clang 3.8.0 by default relies on ubuntu 16.04, and the x64 ubuntu 16.04 clang
# package does not contain x86 compiler-rt 3.8.0 libraries and is complicated
# to install them using multiarch.
# This solution is to create an x86 ubuntu 16.04 to install the libraries and
# copy the files to x64 system.

# The x86 version of the ubuntu system, aims to generate x86 compiler-rt libs
FROM i386/${DISTRO} AS x86_lib_source
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y clang

# ------------------------------------
# The x64 version of the ubuntu system, will be used in package build
FROM ${DISTRO}
# Install essential packages
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

# Install multilib and add x86 multiarch for future installation on dependent
# packages in build
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-dev-i386 \
 && dpkg --add-architecture i386 \
 && apt-get update -y

# Install the clang compiler
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clang

# Copy compiler-rt libraries from x86_lib_source
COPY --from=x86_lib_source \
     /usr/lib/clang/3.8.0/lib/linux/ \
     /usr/lib/clang/3.8.0/lib/linux/

# Define VARs to specify compilation environments
COPY linux_scripts/clang_wrapper.sh /usr/bin/
ENV GT_ORIGIN_CC /usr/bin/clang_wrapper.sh
ENV COMPILER_TAG x86-pc-linux-gnu-clang-3.8.0

ARG DISTRO
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

# Define VARs to specify compilation environments
ENV GT_ORIGIN_CC clang
ENV COMPILER_TAG x86-pc-linux-gnu-clang-6.0.0

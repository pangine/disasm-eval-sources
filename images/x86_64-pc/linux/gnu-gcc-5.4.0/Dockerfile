ARG DISTRO
FROM ${DISTRO}

# Install essential packages
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

# Define VARs to specify compilation environments
ENV GT_ORIGIN_CC gcc
ENV COMPILER_TAG x86_64-pc-linux-gnu-gcc-5.4.0

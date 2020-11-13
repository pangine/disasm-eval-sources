ARG DISTRO
FROM ${DISTRO}

# Install essential packages
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

# Install the clang compiler
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clang

# Define VARs to specify compilation environments
ENV GT_ORIGIN_CC clang
ENV COMPILER_TAG x86_64-pc-linux-gnu-clang-6.0.0

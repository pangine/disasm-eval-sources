ARG DISTRO
FROM ${DISTRO}

# Install essential packages
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

# Install icc dependency
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y cmake \
    cpio \
    libcanberra-gtk-module \
    libgtk2.0 \
    wget

# Download icc tgz
ARG ICC_SHA512SUM="51c8d1b5e84216d35376325558cbf82aeba0bfda2b9214c85bbca828242ae30997cb241ea738c337241076ef31acc2f17eabb4b3a05cd43c8d04c64e4511e8a2"
WORKDIR /root/
RUN wget --progress=bar:force:noscroll https://registrationcenter-download.intel.com/akdlm/irc_nas/16580/intel-sw-tools-installer.tar.gz && \
    if [ "$(sha512sum intel-sw-tools-installer.tar.gz)" != "${ICC_SHA512SUM}  intel-sw-tools-installer.tar.gz" ]; \
    then \
    echo "Warning: icc tgz checksum failed!"; \
    fi && \
    tar zxf intel-sw-tools-installer.tar.gz && \
    rm intel-sw-tools-installer.tar.gz

# Install icc
ARG ICC_KEY
WORKDIR /root/intel-sw-tools-installer
RUN sed -i "s~^ACCEPT_EULA=decline~ACCEPT_EULA=accept~g ; \
            s~^ACTIVATION_TYPE=no_license~ACTIVATION_TYPE=serial_number~g ; \
            s~^#ACTIVATION_SERIAL_NUMBER=snpat~ACTIVATION_SERIAL_NUMBER=${ICC_KEY}~g" silent.cfg && \
    ./install.sh -s silent.cfg

# Define VARs to specify compilation environments
ENV GT_ORIGIN_CC /opt/intel/sw_dev_tools/bin/icc
ENV COMPILER_TAG x86_64-pc-linux-gnu-icc-19.1.1.219

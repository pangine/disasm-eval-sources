ARG IMAGE_TRIPLE
FROM ${IMAGE_TRIPLE}

# Create a user for build packages
ARG UID
ARG USER=ubuntu
ARG USER_HOME=/home/${USER}
RUN useradd -m -d ${USER_HOME} -u ${UID} ${USER}
USER ${USER}
WORKDIR ${USER_HOME}
COPY linux_scripts ./linux_scripts
RUN git config --global user.email "ground.truth@localhost" \
 && git config --global user.name "Ground Truth"

# Install package dependencies
USER root
WORKDIR /root/
ARG ARG_PKG
ENV PKG=${ARG_PKG}
ARG SYSTEM_TRIPLE
COPY packages/${PKG}/${SYSTEM_TRIPLE}/lib_install.sh .
RUN ./lib_install.sh
ENV LINUX_SCRIPTS_DIR ${USER_HOME}/linux_scripts
ENV CC ${LINUX_SCRIPTS_DIR}/gt_cc.sh
ENV CXX ${LINUX_SCRIPTS_DIR}/gt_cxx.sh

# Prepare the build directory
USER ${USER}
WORKDIR ${USER_HOME}
COPY packages/${PKG}/${PKG}.tar.xz .
RUN tar xf ${PKG}.tar.xz && rm ${PKG}.tar.xz

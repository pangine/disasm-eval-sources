# Should come from msvc-wine
ARG DISTRO
FROM ${DISTRO}

# Install essential packages
RUN apt-get update -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git

# Copy the compiler wrapper to replace cl
ENV CL_WRAPPER_BIN /pangine/bin
WORKDIR /
COPY wine_scripts/gtcl.sh .
COPY wine_scripts/cl.exe .
RUN mkdir -p ${CL_WRAPPER_BIN} \
 && mv gtcl.sh ${CL_WRAPPER_BIN} \
 && mv cl.exe ${CL_WRAPPER_BIN} \
 && ln -s ${CL_WRAPPER_BIN}/cl.exe ${CL_WRAPPER_BIN}/cl

# Add the compiler wrapper directory (/root/bin) into WINEPATH
RUN sed -i "s/export WINEPATH=\"\${BINDIR/export WINEPATH=\"z:\\\\\\\\pangine\\\\\\\\bin;\${BINDIR/g" /opt/msvc/bin/x64/msvcenv.sh && \
    echo "export CC=\"z:\\\\pangine\\\\bin\\\\cl\"" >> /opt/msvc/bin/x64/msvcenv.sh && \
    echo "export CXX=\"z:\\\\pangine\\\\bin\\\\cl\"" >> /opt/msvc/bin/x64/msvcenv.sh

# Define VARs to specify compilation environments
ENV GT_ORIGIN_MSVC_WRAPPERS /opt/msvc/bin/x64
ENV GT_ORIGIN_CC ${GT_ORIGIN_MSVC_WRAPPERS}/cl
ENV GT_ORIGIN_CXX ${GT_ORIGIN_MSVC_WRAPPERS}/cl
ENV PATH="/opt/msvc/bin/x64:/opt/msvc/vc/tools/msvc/14.25.28610/bin/Hostx64/x64:${PATH}"
ENV COMPILER_TAG x86_64-pc-linux-msvc-cl-19.25.28614

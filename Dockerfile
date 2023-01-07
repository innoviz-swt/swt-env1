# syntax based on https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# default BASE
ARG BASE="focal"

# Start from base image of ubuntu - see https://hub.docker.com/_/ubuntu 
FROM swt-pyenv-${BASE}:0.1.0

# Run enviroment setup flow
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
    vim \
    # required for opengl
    # opengl required installations mesa-common-dev
    # libxi-dev required for freeglut3-dev https://stackoverflow.com/questions/5299989/x11-xlib-h-not-found-in-ubuntu
    libgl-dev freeglut3-dev libxi-dev \
    # using PCL cpp library
    libpcl-dev \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*

# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#package-manager
RUN apt-get update && apt-get install linux-headers-$(uname -r) && \
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g') && \
    echo distribution $distribution %% \
    wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-keyring_1.0-1_all.deb && \
    sudo dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*

# Install nvidia toolkit
# Update the APT repository cache and install the driver using the cuda-drivers meta-package. Use the --no-install-recommends option for a lean driver install without any dependencies on X packages. This is particularly useful for headless installations on cloud instances.
RUN apt-get update && \
    apt-get -y install cuda-drivers && \
    apt-get -y install nvidia-cuda-toolkit && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*

# install required python versions
# RUN pyenv install 3.6.15
# RUN pyenv install 3.10.9

# Set docker labels
# version format: "{major}.{minor}.{patch}"
ARG VER BUILD BASE
LABEL version=${VER} \
      build=${BUILD} \
      base=${BASE} \
      description="This is Docker Image with env set #1 installed." \
      source-code="https://github.com/innoviz-swt/swt-evn1"

# Set default CMD
CMD ["/bin/bash"]
# syntax based on https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# default BASE
ARG BASE="focal"

# Start from base image of ubuntu - see https://hub.docker.com/_/ubuntu 
FROM swt-pyenv-${BASE}:0.1.0

# Run enviroment setup flow
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
    vim \
    libpcl-dev \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*
 
# install required python versions
RUN pyenv install 3.6.15
RUN pyenv install 3.10.9

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
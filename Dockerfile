# syntax based on https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
# default BASE
ARG BASE="nvidia/cuda:11.7.1-base-ubuntu18.04"

# Start from base image of ubuntu - see https://hub.docker.com/_/ubuntu 
FROM $BASE

#########
# Pyenv #
#########

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
  curl \
  git \
  ca-certificates \
  build-essential \
  ## pyenv - python dependencies, https://github.com/pyenv/pyenv/wiki/Common-build-problems
  libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl\
  # clean apt-get cache
  && apt-get clean && rm -rf /var/lib/apt/lists/*
 
###########
# CV Perc #
###########
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -y \
    # utils
    cmake \
    cron \
    sudo \
    iputils-ping \
    vim \
    # required by git 
    openssh-client \
    # required for opengl
    # opengl required installations mesa-common-dev
    # libxi-dev required for freeglut3-dev https://stackoverflow.com/questions/5299989/x11-xlib-h-not-found-in-ubuntu
    libgl-dev freeglut3-dev libxi-dev \
    # using PCL cpp library
    libpcl-dev \
    && apt-get clean all && rm -rf /var/lib/apt/lists/*

# pyenv, https://github.com/pyenv/pyenv
RUN git clone https://github.com/pyenv/pyenv /usr/share/pyenv --depth 1
ENV PYENV_ROOT /usr/share/pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
ENV PATH $PYENV_ROOT/shims:$PATH

RUN mkdir -p $PYENV_ROOT/shims $PYENV_ROOT/versions && \
    touch $PYENV_ROOT/version && \
    chmod 777 $PYENV_ROOT/shims $PYENV_ROOT/versions $PYENV_ROOT/version

RUN echo "" >> ~/.bashrc && \
    echo "# pyenv" >> ~/.bashrc && \
    echo "eval \"\$(pyenv init -)\"" >> ~/.bashrc && \
    echo "" >> ~/.bashrc


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
      source-code="https://github.com/innoviz-swt/swt-env1"

# Set default CMD
CMD ["/bin/bash"]
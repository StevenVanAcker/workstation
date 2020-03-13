#!/bin/sh -e

if [ "$INSTALL_PWNTOOLS" = "no" ];
then
    exit 0
fi


# pre-requisites
apt-get install -y binutils-arm-linux-gnueabi

# Install pwntools
pip install pwn

# install foresight
pip3 install git+https://github.com/ALSchwalm/foresight


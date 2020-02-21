#!/bin/sh -e

# pre-requisites
apt-get install -y binutils-arm-linux-gnueabi

# Install pwntools
pip install pwn

# install foresight
pip3 install git+https://github.com/ALSchwalm/foresight


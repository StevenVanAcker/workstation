#!/bin/sh -e

# DESCRIPTION: Gallopsled's pwntools python library

# pre-requisites
apt-get install -y binutils-arm-linux-gnueabi

# Install pwntools
pip3 install pwn --break-system-packages

# install foresight
pip3 install git+https://github.com/ALSchwalm/foresight --break-system-packages

#!/bin/sh -e

# DESCRIPTION: Gallopsled's pwntools python library

# pre-requisites
yes | aptdcon --hide-terminal --install="binutils-arm-linux-gnueabi python3 python3-pip"

# Install pwntools
pip3 install pwn

# install foresight
pip3 install git+https://github.com/ALSchwalm/foresight

#!/bin/sh -e
# DESCRIPTION: QEMU-powered tool to create instant VMs for running binaries


apt-get install -y qemu-system e2tools
pip3 install https://github.com/nongiach/arm_now/archive/master.zip --upgrade

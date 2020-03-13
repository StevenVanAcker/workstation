#!/bin/sh -e

if [ "$INSTALL_ARM_NOW" = "no" ];
then
    exit 0
fi


apt-get install -y qemu-system e2tools
pip3 install https://github.com/nongiach/arm_now/archive/master.zip --upgrade

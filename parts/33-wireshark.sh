#!/bin/sh -e

if [ "$INSTALL_WIRESHARK" = "no" ];
then
    exit 0
fi


# Install wireshark

export DEBIAN_FRONTEND=noninteractive

# add-apt-repository -y ppa:wireshark-dev/nightly
# apt update
apt-get install -y wireshark tshark


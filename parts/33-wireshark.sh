#!/bin/sh -e

# Install wireshark

export DEBIAN_FRONTEND=noninteractive

# add-apt-repository -y ppa:wireshark-dev/nightly
# apt update
apt-get install -y wireshark tshark


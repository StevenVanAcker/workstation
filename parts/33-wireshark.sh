#!/bin/sh -e

# Install latest wireshark

export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:wireshark-dev/stable
apt update
apt-get install -y wireshark tshark


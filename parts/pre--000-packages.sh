#!/bin/sh -e

# Install a bunch of packages used on a workstation
# add i386 architecture
dpkg --add-architecture i386

# enable source repos
sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"

apt-get update
apt-get upgrade -y

# devel tools
apt-get install -y git vim build-essential ipython3 python3-pip python3-venv gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386 linux-libc-dev:i386 cargo

# net tools
apt-get install -y nmap tcpdump net-tools tcptraceroute netcat telnet tcptrace curl python3-scapy traceroute hping3 lynx wireshark tshark wireguard whois minicom

# GUI stuff
apt-get install -y inkscape gimp libreoffice
# WARNING: inkscape uses python2

# remastering CD
apt-get install -y xorriso isolinux ovmf syslinux-utils debconf-utils genisoimage

# other
apt-get install -y openjdk-11-jdk gnupg2 apt-transport-https p7zip-full exfat-fuse graphviz binwalk sqlite ubuntu-restricted-addons jq transmission pv remmina software-properties-common parallel



####################
# pip packages
####################

piplist="	xortool \
			websocket-client \
			flake8 \
			autopep8 \
			"

pip3 install $piplist

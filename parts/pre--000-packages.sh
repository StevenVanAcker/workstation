#!/bin/sh -e

# Install a bunch of packages used on a workstation
# add i386 architecture
dpkg --add-architecture i386

apt-get update
apt-get upgrade -y

# devel tools
apt-get install -y git vim build-essential ipython3 python3-pip gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386

# net tools
apt-get install -y nmap tcpdump net-tools tcptraceroute netcat telnet tcptrace curl python3-scapy traceroute hping3 lynx wireshark tshark

# virtualization
apt-get install -y docker.io docker-compose dosbox qemu-user-static

# GUI stuff
apt-get install -y inkscape gimp 
# WARNING: inkscape uses python2

# texlive-full takes 4.6GB
# apt-get install -y texlive-full

# remastering CD
apt-get install -y xorriso isolinux ovmf syslinux-utils debconf-utils

# other
apt-get install -y openjdk-11-jdk gnupg2 apt-transport-https p7zip-full exfat-fuse graphviz binwalk sqlite ubuntu-restricted-addons jq



####################
# pip packages
####################

piplist="	xortool \
			websocket-client \
			"

pip3 install $piplist

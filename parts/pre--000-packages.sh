#!/bin/sh -e

# Install a bunch of packages used on a workstation
# add i386 architecture
dpkg --add-architecture i386

# enable source repos
echo ">>> Enabling source repos"
sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"

#echo ">>> Enabling updates repos"
#apt-get update
#apt-get install -y lsb-release software-properties-common
#apt-add-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -cs)-updates main restricted universe multiverse" 

echo ">>> Performing upgrade"
yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --full-upgrade

PACKAGES=""
# devel tools
PACKAGES="$PACKAGES git vim build-essential ipython3 python3-pip python3-venv gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386 linux-libc-dev:i386 cargo \
	python3-flake8 python3-autopep8 python3-websocket"

# net tools
PACKAGES="$PACKAGES nmap tcpdump net-tools tcptraceroute netcat-openbsd telnet tcptrace curl python3-scapy traceroute hping3 lynx wireshark tshark wireguard whois \
	minicom ipset dnsmasq hostapd arp-scan openssh-server"

# GUI stuff
PACKAGES="$PACKAGES inkscape gimp libreoffice"
# WARNING: inkscape uses python2

# remastering CD
PACKAGES="$PACKAGES xorriso isolinux ovmf syslinux-utils debconf-utils genisoimage"

# other
PACKAGES="$PACKAGES openjdk-11-jdk gnupg2 apt-transport-https p7zip-full exfat-fuse graphviz binwalk sqlite3 ubuntu-restricted-addons jq transmission pv remmina \
	software-properties-common parallel bmap-tools htop ldap-utils"

# install bitwarden
PACKAGES="$PACKAGES npm"
yes | aptdcon --hide-terminal --install="$PACKAGES"
npm install -g @bitwarden/cli



####################
# pip packages
####################

piplist="	xortool \
			"

pip3 install --break-system-packages $piplist

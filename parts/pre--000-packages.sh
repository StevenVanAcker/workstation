#!/bin/sh -e

# Install a bunch of packages used on a workstation
# add i386 architecture
dpkg --add-architecture i386

# enable source repos
echo ">>> Enabling source repos"
sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"

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

yes | aptdcon --hide-terminal --install="$PACKAGES"

# install bitwarden
export RELEASE=$(lsb_release -rs)

if [ "$RELEASE" = "22.04" ];
then
	echo """# Ubuntu $RELEASE detected, installing upstream nodejs"
	curl -fsSL https://deb.nodesource.com/setup_21.x | bash -e
	yes | aptdcon --hide-terminal --install="nodejs"
else
	echo """# Ubuntu $RELEASE detected, installing npm via apt"
	yes | aptdcon --hide-terminal --install="npm"
fi

npm install -g @bitwarden/cli


####################
# pip packages
####################

piplist="	xortool \
			"

# remove the need for --break-system-packages, since that would not be
# compatible with older versions pip
rm -f /usr/lib/python*/EXTERNALLY-MANAGED
pip3 install $piplist

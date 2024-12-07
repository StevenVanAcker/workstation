#!/bin/sh -e

# Install a bunch of packages used on a workstation
# add i386 architecture
dpkg --add-architecture i386

# enable source repos
echo ">>> Enabling source repos"
sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"

echo ">>> Performing refresh"
yes | aptdcon --hide-terminal --refresh

echo ">>> Installing rbw"
yes | aptdcon --hide-terminal --install="curl jq"
RBWVER=$(curl -s https://api.github.com/repos/doy/rbw/releases | jq '.[0].tag_name' --raw-output)
echo ">>> Found rbw version $RBWVER"
curl -o rbw.deb "https://git.tozt.net/rbw/releases/deb/rbw_${RBWVER}_amd64.deb"
dpkg -i rbw.deb
rm -f rbw.deb

echo ">>> Checking whether rbw works"
rbw --version

echo ">>> Performing upgrade"
yes | aptdcon --hide-terminal --full-upgrade

# install bitwarden and rbw
yes | aptdcon --hide-terminal --install="curl jq"
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

PACKAGES=""
# devel tools
PACKAGES="$PACKAGES git vim build-essential ipython3 python3-pip python3-venv gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386 linux-libc-dev:i386 cargo \
	python3-flake8 python3-autopep8 python3-websocket unzip python-dev-is-python3"

# net tools
PACKAGES="$PACKAGES nmap tcpdump net-tools tcptraceroute netcat-openbsd telnet tcptrace curl python3-scapy traceroute hping3 lynx wireshark tshark wireguard whois \
	minicom ipset dnsmasq hostapd arp-scan openssh-server avahi-utils"

# GUI stuff
PACKAGES="$PACKAGES inkscape gimp libreoffice"
# WARNING: inkscape uses python2

# remastering CD
PACKAGES="$PACKAGES xorriso isolinux ovmf syslinux-utils debconf-utils genisoimage"

# other
PACKAGES="$PACKAGES openjdk-11-jdk gnupg gnupg2 apt-transport-https p7zip-full exfat-fuse graphviz binwalk sqlite3 ubuntu-restricted-addons jq transmission pv remmina \
	remmina-plugin-vnc remmina-plugin-rdp \
	software-properties-common parallel bmap-tools htop ldap-utils distro-info qrencode supervisor \
	zbar-tools"

yes | aptdcon --hide-terminal --install="$PACKAGES"


####################
# pip packages
####################

piplist="	xortool \
			"

# remove the need for --break-system-packages, since that would not be
# compatible with older versions pip
rm -f /usr/lib/python*/EXTERNALLY-MANAGED
pip3 install $piplist

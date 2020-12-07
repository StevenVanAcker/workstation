#!/bin/sh -e

# Install a bunch of packages used on a workstation

apt-get update
apt-get upgrade -y

# if we're not in a VM, install virtualbox
if [ "$INSIDEVM" = "no" ];
then
	apt-get install -y virtualbox
fi

# devel tools
apt-get install -y git vim build-essential maven ipython3 python3-pip vim-python-jedi gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386

# net tools
apt-get install -y nmap tcpdump net-tools tcptraceroute netcat telnet tcptrace curl python3-scapy traceroute hping3 lynx

# virtualization
apt-get install -y ansible docker.io docker-compose dosbox

# GUI stuff
apt-get install -y gnome-tweak-tool inkscape gimp 
# WARNING: inkscape uses python2

# texlive-full takes 4.6GB
# apt-get install -y texlive-full

# remastering CD
apt-get install -y xorriso isolinux ovmf syslinux-utils

# mount samba shares
apt-get install -y smbclient samba cifs-utils keyutils ldapscripts

# other
apt-get install -y openjdk-11-jdk gnupg2 vim-python-jedi apt-transport-https p7zip-full exfat-fuse graphviz binwalk sqlite



####################
# pip packages
####################

piplist="	xortool \
			websocket-client \
			"

pip3 install $piplist

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
apt-get install -y git vim build-essential maven ipython ipython3 python-pip python3-pip vim-python-jedi gdb-multiarch mdm nasm cmake gcc-multilib libseccomp2:i386

# net tools
apt-get install -y nmap tcpdump net-tools tcptraceroute netcat telnet tcptrace curl python-scapy python3-scapy traceroute hping3 lynx

# virtualization
apt-get install -y ansible docker.io docker-compose dosbox

# GUI stuff
apt-get install -y gnome-tweak-tool inkscape gimp xpdf

# texlive-full takes 4.6GB
# apt-get install -y texlive-full

# remastering CD
apt-get install -y system-config-kickstart xorriso isolinux ovmf

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

pip install $piplist
pip3 install $piplist

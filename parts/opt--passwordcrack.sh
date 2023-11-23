#!/bin/sh -e

# DESCRIPTION: John The Ripper password cracking tool

install_john=true

yes | aptdcon --hide-terminal --install="hashcat"

if [ "$install_john" = "true" -a ! -e /opt/JohnTheRipper ];
then
	echo "==> Installing JohnTheRipper from https://github.com/magnumripper/JohnTheRipper.git"
	yes | aptdcon --hide-terminal --install="build-essential python3-pip zlib1g-dev libssl-dev git mdm \
		yasm libgmp-dev libpcap-dev pkg-config libbz2-dev \
		nvidia-opencl-dev \
		libcompress-raw-lzma-perl python3-pyasn1 \
		python3-protobuf python3-dpkt \
		libnet-pcap-perl libnetpacket-perl libnet-radius-perl \
		python3-ldap3 python3-ldapdomaindump jxplorer"
	pip3 install plyvel parsimonious --break-system-packages
	# WARNING: had to remove pysap, doesn't work in python3 pip
	cd /opt
	git clone https://github.com/magnumripper/JohnTheRipper.git
	cd JohnTheRipper/src
	./configure
	make -sj$(ncpus)

	echo 'export PATH="/opt/JohnTheRipper/run/:$PATH"' >> /etc/bash.bashrc
fi

if [ "$install_john" = "true" -a ! -e /opt/SecLists.zip ];
then
	echo "==> Getting password lists"
	wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O /opt/SecLists.zip
	cd /opt
    unzip SecLists.zip
fi


# https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
# https://gist.github.com/scottlinux/9a3b11257ac575e4f71de811322ce6b3
# https://www.hack3r.com/forum-topic/wikipedia-wordlist
# https://github.com/Porchetta-Industries/CrackMapExec


#!/bin/sh -e

# DESCRIPTION: John The Ripper password cracking tool

install_john=true

apt-get install -y hashcat

if [ "$install_john" = "true" -a ! -e /opt/JohnTheRipper ];
then
	echo "==> Installing JohnTheRipper from https://github.com/magnumripper/JohnTheRipper.git"
	apt-get -y install build-essential python3-pip zlib1g-dev libssl-dev git mdm \
		yasm libgmp-dev libpcap-dev pkg-config libbz2-dev \
		nvidia-opencl-dev \
		libcompress-raw-lzma-perl python3-pyasn1 \
		python3-protobuf python3-dpkt \
		libnet-pcap-perl libnetpacket-perl libnet-radius-perl \
		python3-ldap3
	pip3 install plyvel parsimonious
	# WARNING: had to remove pysap, doesn't work in python3 pip
	cd /opt
	git clone https://github.com/magnumripper/JohnTheRipper.git
	cd JohnTheRipper/src
	./configure
	make -sj$(ncpus)

	echo 'export PATH="/opt/JohnTheRipper/run/:$PATH"' >> /etc/bash.bashrc
fi


# https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
# https://gist.github.com/scottlinux/9a3b11257ac575e4f71de811322ce6b3
# https://www.hack3r.com/forum-topic/wikipedia-wordlist

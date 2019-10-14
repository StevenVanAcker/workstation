#!/bin/sh -e

install_john=true

apt-get install -y hashcat

if [ "$install_john" = "true" -a ! -e /opt/JohnTheRipper ];
then
	echo "==> Installing JohnTheRipper from https://github.com/magnumripper/JohnTheRipper.git"
	apt-get -y install build-essential python-pip python3-pip zlib1g-dev libssl-dev git mdm \
		yasm libgmp-dev libpcap-dev pkg-config libbz2-dev \
		nvidia-opencl-dev \
		libcompress-raw-lzma-perl python-pyasn1 python3-pyasn1 \
		python-protobuf python3-protobuf python-dpkt python3-dpkt \
		libnet-pcap-perl libnetpacket-perl libnet-radius-perl \
		python-ldap3 python3-ldap3
	pip install plyvel parsimonious pysap
	pip3 install plyvel parsimonious 
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

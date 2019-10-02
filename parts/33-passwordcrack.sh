#!/bin/sh -e

install_john=true

apt-get install -y hashcat

if [ "$install_john" = "true" -a ! -e /opt/JohnTheRipper ];
then
	echo "==> Installing JohnTheRipper from https://github.com/magnumripper/JohnTheRipper.git"
	apt-get -y install build-essential zlib1g-dev libssl-dev git \
		yasm libgmp-dev libpcap-dev pkg-config libbz2-dev \
		nvidia-opencl-dev
	cd /opt
	git clone https://github.com/magnumripper/JohnTheRipper.git
	cd JohnTheRipper/src
	./configure
	make -sj$(ncpus)

	echo 'export PATH="/opt/JohnTheRipper/run/:$PATH"' >> /etc/bash.bashrc
fi


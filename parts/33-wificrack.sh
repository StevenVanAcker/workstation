#!/bin/sh -e

install_bully=true
install_hcxdumptool=true
install_hcxtools=true

apt-get install -y \
	aircrack-ng \
	wifite \
	reaver \
	weplab \
	pyrit \
	pyrit-opencl \
	macchanger \
	cowpatty

if [ "$install_bully" = "true" -a ! -e /opt/bully ];
then
	echo "==> Installing bully from https://github.com/aanarchyy/bully"
	apt-get -y install build-essential libpcap-dev aircrack-ng pixiewps
	cd /opt
	git clone https://github.com/aanarchyy/bully
	cd bully/src
	make -j $(ncpus)
	make install
fi

if [ "$install_hcxdumptool" = "true" -a ! -e /opt/hcxdumptool ];
then
	echo "==> Installing hcxdumptool from https://github.com/ZerBea/hcxdumptool"
	apt-get -y install build-essential libssl-dev
	cd /opt
	git clone https://github.com/ZerBea/hcxdumptool
	cd hcxdumptool
	make -j $(ncpus)
	make install
fi

if [ "$install_hcxtools" = "true" -a ! -e /opt/hcxtools ];
then
	echo "==> Installing hcxtools from https://github.com/ZerBea/hcxtools"
	apt-get -y install build-essential libssl-dev libcurl4-openssl-dev zlib1g-dev
	cd /opt
	git clone https://github.com/ZerBea/hcxtools
	cd hcxtools
	make -j $(ncpus)
	make install
fi

# airmon-ng stop wlp2s0mon

#!/bin/sh -e

# DESCRIPTION: several WiFi cracking tools


install_bully=true
install_hcxdumptool=true
install_hcxtools=true

yes | aptdcon --hide-terminal --install="\
	aircrack-ng \
	wifite \
	reaver \
	weplab \
	macchanger \
	cowpatty"

if [ "$install_bully" = "true" -a ! -e /opt/bully ];
then
	echo "==> Installing bully from https://github.com/aanarchyy/bully"
	yes | aptdcon --hide-terminal --install="build-essential libpcap-dev aircrack-ng pixiewps"
	cd /opt
	git clone https://github.com/aanarchyy/bully
	cd bully/src
	make -j $(ncpus)
	make install
fi

if [ "$install_hcxdumptool" = "true" -a ! -e /opt/hcxdumptool ];
then
	echo "==> Installing hcxdumptool from https://github.com/ZerBea/hcxdumptool"
	yes | aptdcon --hide-terminal --install="build-essential libssl-dev"
	cd /opt
	git clone https://github.com/ZerBea/hcxdumptool
	cd hcxdumptool
	make -j $(ncpus)
	make install
fi

if [ "$install_hcxtools" = "true" -a ! -e /opt/hcxtools ];
then
	echo "==> Installing hcxtools from https://github.com/ZerBea/hcxtools"
	yes | aptdcon --hide-terminal --install="build-essential libssl-dev libcurl4-openssl-dev zlib1g-dev"
	cd /opt
	git clone https://github.com/ZerBea/hcxtools
	cd hcxtools
	make -j $(ncpus)
	make install
fi

# airmon-ng stop wlp2s0mon

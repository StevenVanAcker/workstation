#!/bin/sh -e

# Install OpenOCD according to https://research.kudelskisecurity.com/2014/05/01/jtag-debugging-made-easy-with-bus-pirate-and-openocd/
apt-get install -y libtool autoconf texinfo libusb-dev libftdi-dev libusb-1.0-0-dev

if [ ! -d /opt/openocd ];
then
	cd /opt
	git clone git://git.code.sf.net/p/openocd/code openocd
	cd openocd
	./bootstrap
	./configure --enable-maintainer-mode --disable-werror --enable-buspirate
	make -j$(ncpus)
	make install
fi


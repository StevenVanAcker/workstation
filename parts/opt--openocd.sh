#!/bin/sh -e


# DESCRIPTION: OpenOCD Open On-Chip Debugger to interface with JTAG

apt-get install -y git make mdm

# Install OpenOCD according to https://research.kudelskisecurity.com/2014/05/01/jtag-debugging-made-easy-with-bus-pirate-and-openocd/
apt-get install -y libtool autoconf texinfo libusb-dev libftdi-dev libusb-1.0-0-dev
# extra https://stackoverflow.com/questions/8811381/possibly-undefined-macro-ac-msg-error
apt-get install -y pkg-config autoconf-archive

if [ ! -d /opt/openocd ];
then
	cd /opt
	git clone git://git.code.sf.net/p/openocd/code openocd
	cd openocd
	./bootstrap
	./configure --enable-maintainer-mode --disable-werror --enable-buspirate --disable-dependency-tracking
	make -j$(ncpus)
	make install
fi


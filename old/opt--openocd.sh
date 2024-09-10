#!/bin/sh -e

# DESCRIPTION: OpenOCD Open On-Chip Debugger to interface with JTAG


echo "=== Disabling openocd installation because repo errors with 403 on 2021-12-29"
exit 0;

yes | aptdcon --hide-terminal --install="git make mdm"

# Install OpenOCD according to https://research.kudelskisecurity.com/2014/05/01/jtag-debugging-made-easy-with-bus-pirate-and-openocd/
yes | aptdcon --hide-terminal --install="libtool autoconf texinfo libusb-dev libftdi-dev libusb-1.0-0-dev"

# extra https://stackoverflow.com/questions/8811381/possibly-undefined-macro-ac-msg-error
yes | aptdcon --hide-terminal --install="pkg-config autoconf-archive"

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


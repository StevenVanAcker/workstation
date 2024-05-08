#!/bin/sh -e
# DESCRIPTION: Arduino IDE and CLI

base="https://www.arduino.cc/en/software/"
boards="http://drazzy.com/package_drazzy.com_index.json http://digistump.com/package_digistump_index.json"

if [ ! -e /opt/arduino ];
then
	yes | aptdcon --hide-terminal --install="avr-libc avrdude gcc-avr binutils-avr lynx"

	tmpfile=$(mktemp --suffix .tar.xz)

	echo "==> Checking for latest Arduino IDE version"
	url=$(lynx -dump "$base" | grep -oP "https?://.*download.*(/arduino-[0123456789\.]+-linux64.tar.*)$")

	echo "==> Downloading latest Arduino IDE to $tmpfile from $url"

	curl -Lo $tmpfile "$url"
	echo "==> Unpacking..."
	cd /opt
	tar -xf $tmpfile
	mv arduino-* arduino

	echo "==> Installing as root"
	cd arduino
	./install.sh
	echo "==> Installing as $MAINUSER to setup defaults in desktop env"
	su -c ./install.sh $MAINUSER


	echo "==> Cleaning up"
	rm -f $tmpfile

	echo "==> Done."
fi

if [ ! -e /usr/bin/arduino-cli ];
then
	echo "==> Installing arduin-cli"
	curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/bin/ sh
	echo "==> Done."
fi

if [ ! -e /home/$MAINUSER/.arduino15/arduino-cli.yaml ];
then
	echo "==> Configuring extra boards"
	commaboards=$(echo $boards | tr " " ",")
	su -c sh $MAINUSER <<EOF
arduino-cli config init
arduino-cli config set board_manager.additional_urls $boards
arduino-cli core update-index
arduino-cli core install ATTinyCore:avr digistump:avr
arduino --pref "boardsmanager.additional.urls=$commaboards" --save-prefs
EOF
	echo "==> Done."
fi

oldmn="/home/$MAINUSER/.arduino15/packages/digistump/tools/micronucleus/2.0a4/micronucleus"
if [ -e "$oldmn" -a ! -L "$oldmn" ];
then
	echo "==> digistump installed old micronucleus at $oldmn"
	newmn=$(ls /home/$MAINUSER/.arduino15/packages/ATTinyCore/tools/micronucleus/*/micronucleus)
	echo "==> replacing it with symlink to $newmn"
	mv $oldmn $oldmn.old
	su -c "ln -s $newmn $oldmn" $MAINUSER
	echo "==> Done."
fi

if [ ! -e /etc/udev/rules.d/49-micronucleus.rules ];
then
	echo "==> Creating /etc/udev/rules.d/49-micronucleus.rules"
	mkdir -p /etc/udev/rules.d
	curl -Lo /etc/udev/rules.d/49-micronucleus.rules https://github.com/micronucleus/micronucleus/blob/master/commandline/49-micronucleus.rules
	echo "==> Done."
fi


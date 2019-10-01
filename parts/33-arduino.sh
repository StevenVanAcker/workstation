#!/bin/sh -e

base="https://www.arduino.cc/en/Main/Software"

if [ -e /opt/arduino ];
then
	# already installed
	exit 0
fi

apt-get install -y lynx curl avr-libc avrdude gcc-avr binutils-avr

tmpfile=$(tempfile -s tar.xz)

echo "==> Checking for latest Arduino IDE version"
urlpath=$(lynx -dump "$base" | grep -oP "https?://.*download.*\?f=(/arduino-[0123456789\.]+-linux64.tar.*)$" | sed 's:.*?f=::')
url="https://downloads.arduino.cc$urlpath"

echo "==> Downloading latest Arduino IDE to $tmpfile from $url"
curl -o $tmpfile "$url"

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

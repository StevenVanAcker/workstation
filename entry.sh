#!/bin/sh -e

apt-get update
apt-get install -y git sudo

if [ "$CLONEHERE" != "1" ];
then
	tmpdir=$(mktemp -d)
	cd $tmpdir
	echo "Cloning in $tmpdir"
else
	echo "Cloning in $PWD"
fi

git clone https://github.com/StevenVanAcker/workstation.git
cd workstation
./install.sh

if [ "$CLONEHERE" != "1" ];
then
	echo "Removing $tmpdir"
	cd /
	rm -rf $tmpdir
fi
echo "Done."

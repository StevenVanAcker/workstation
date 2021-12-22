#!/bin/sh -e

# DESCRIPTION: Steam, the ultimate online game platform

dpkg -l steam && echo "==> Steam already installed." && exit 0

dpkg --add-architecture i386
apt-get update && apt-get install -y steam

nvidia386=$(dpkg -l |grep -oP "libnvidia-gl-.*:amd64" | sed 's:amd64:i386:')

if [ -n "$nvidia386" ];
then
	echo "==> Installing i386 version of nvidia driver"
	apt-get install -y $nvidia386
	echo "==> Done."
fi

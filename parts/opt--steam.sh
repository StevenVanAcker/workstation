#!/bin/sh -e

# DESCRIPTION: Steam, the ultimate online game platform

dpkg -s steam && echo "==> Steam already installed." && exit 0

dpkg --add-architecture i386
yes | aptdcon --hide-terminal --refresh
yes | ( aptdcon --hide-terminal --install="steam" || aptdcon --hide-terminal --install="steam-installer" )

nvidia386=$(dpkg -l |grep -oP "libnvidia-gl-.*:amd64" | sed 's:amd64:i386:')

if [ -n "$nvidia386" ];
then
	echo "==> Installing i386 version of nvidia driver"
	yes | aptdcon --hide-terminal --install="$nvidia386"
	echo "==> Done."
fi

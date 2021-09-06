#!/bin/sh -e

# DESCRIPTION: Minecraft game

dpkg -l minecraft-launcher && echo "==> Minecraft already installed." && exit 0

f=$(mktemp --suffix=.deb)
echo "==> Downloading minecraft to $f"
curl -Lo $f https://launcher.mojang.com/download/Minecraft.deb
echo "==> Installing package $f"
apt -y install $f
echo "==> Cleaning up"
rm -f $f
echo "==> Done installing minecraft"


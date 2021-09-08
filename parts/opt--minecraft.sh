#!/bin/sh -e

# DESCRIPTION: Minecraft game

export MAINUSER=$(id -nu 1000)
DLDIR=/opt/downloads/minecraft
mkdir -p $DLDIR

if dpkg -l minecraft-launcher; then
	echo "==> Minecraft already installed."
else
	# installing minecraft
	echo "==> Downloading minecraft to $DLDIR/minecraft.deb"
	curl -Lo $DLDIR/minecraft.deb https://launcher.mojang.com/download/Minecraft.deb
	echo "==> Installing package"
	apt -y install $DLDIR/minecraft.deb
	#echo "==> Launching minecraft-launcher as $MAINUSER to create directories"
	#su -c "minecraft-launcher --help" $MAINUSER
	echo "==> Done installing minecraft"
fi

if [ -e $DLDIR/fabric-installer.jar ]; then
	echo "==> Fabric already installed."
else
	fabricurl=$(curl 'https://meta.fabricmc.net/v2/versions/installer'   | jq .[0].url -r)
	echo "==> Downloading fabric installer from $fabricurl"
   	curl -Lo $DLDIR/fabric-installer.jar $fabricurl

	#echo "==> Running fabric-installer as $MAINUSER"
	#su -c "java -jar $DLDIR/fabric-installer.jar client" $MAINUSER
	echo "==> Done installing fabric"
fi

# TODO: install fabric loader, fabric API, optifine, optifabric

# TODO Create script for this...


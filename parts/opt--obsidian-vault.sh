#!/bin/sh -e

# DESCRIPTION: Obsidian, the markdown-based knowledge base app, plus Syncthing for vault sync

export MAINUSER=$(id -nu 1000)
export MAINHOME=$(getent passwd $MAINUSER | cut -d: -f 6)

if dpkg -s obsidian > /dev/null 2>&1;
then
	echo "==> Obsidian already installed."
else
	tmpfile=$(mktemp --suffix .deb)
	trap "rm -f $tmpfile" EXIT

	echo "==> Looking up latest Obsidian .deb from https://obsidian.md/download"
	url=$(curl -s https://obsidian.md/download | grep -oiP 'https://github\.com/obsidianmd/obsidian-releases/releases/download/[^"'"'"']+_amd64\.deb' | head -1)

	if [ -z "$url" ];
	then
		echo "==> Could not find a .deb download URL on the Obsidian download page." 1>&2
		exit 1
	fi

	echo "==> Downloading $url to $tmpfile"
	curl -Lo $tmpfile "$url"

	# libasound2t64 is not declared as a dependency of the .deb, but the
	# bundled Electron runtime needs it to start.
	apt install -y $tmpfile libasound2t64

	dpkg -s obsidian > /dev/null 2>&1 || { echo "==> Obsidian installation failed, dpkg does not report it as installed." 1>&2; exit 1; }

	command -v obsidian > /dev/null 2>&1 || { echo "==> Obsidian is installed but the 'obsidian' binary is not on PATH." 1>&2; exit 1; }

	echo "==> Obsidian $(dpkg-query -W -f='${Version}' obsidian) installed successfully."
fi

echo "==> Installing syncthing and syncthingtray"
yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="syncthing syncthingtray"

dpkg -s syncthing > /dev/null 2>&1 || { echo "==> syncthing installation failed, dpkg does not report it as installed." 1>&2; exit 1; }
dpkg -s syncthingtray > /dev/null 2>&1 || { echo "==> syncthingtray installation failed, dpkg does not report it as installed." 1>&2; exit 1; }

echo "==> Syncthing $(dpkg-query -W -f='${Version}' syncthing) and syncthingtray $(dpkg-query -W -f='${Version}' syncthingtray) installed successfully."

echo "==> Enabling and starting syncthing service for $MAINUSER"
systemctl enable --now "syncthing@$MAINUSER.service" || echo "Failed but that's ok..."

echo "==> Setting up syncthingtray to autostart on login for $MAINUSER"
mkdir -p $MAINHOME/.config/autostart
cp /usr/share/applications/syncthingtray.desktop $MAINHOME/.config/autostart/syncthingtray.desktop
chown -R $MAINUSER: $MAINHOME/.config/autostart

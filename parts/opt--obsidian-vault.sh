#!/bin/sh -e

# DESCRIPTION: Obsidian, the markdown-based knowledge base app

dpkg -s obsidian > /dev/null 2>&1 && echo "==> Obsidian already installed." && exit 0

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

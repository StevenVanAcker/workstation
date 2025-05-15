#!/bin/sh -e

# DESCRIPTION: Signal messaging app for desktop

dpkg -s signal-desktop && echo "==> Signal already installed." && exit 0

tf=$(mktemp)
curl -L https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > $tf
install -o root -g root -m 644 $tf /etc/apt/trusted.gpg.d/signal-desktop-keyring.gpg
rm -f $tf

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' > /etc/apt/sources.list.d/signal.list


yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="signal-desktop"




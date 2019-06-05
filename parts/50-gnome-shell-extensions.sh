#!/bin/bash

user=$(getent passwd 1000 | cut -d: -f1)

apt-get install -y gnome-tweak-tool git

# FIXME
rm -rf ~$user/.local/share/gnome-shell/extensions ~$user/Projects.git

su $user <<EOF
mkdir -p ~/.local/share/gnome-shell/extensions
mkdir -p ~/Projects.git
cd ~/Projects.git
git clone https://github.com/Shihira/gnome-extension-quicktoggler.git
cd gnome-extension-quicktoggler/quicktoggler@shihira.github.com
make install

gnome-shell-extension-tool -e quicktoggler@shihira.github.com
EOF

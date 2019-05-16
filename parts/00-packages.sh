#!/bin/sh -e

apt-get update
apt-get upgrade -y

# devel tools
apt-get install -y git vim build-essential maven ipython ipython3 python-pip python3-pip vim-python-jedi

# net tools
apt-get install -y wireshark nmap tcpdump minicom net-tools tcptraceroute netcat telnet tcptrace

# virtualization
apt-get install -y ansible docker.io docker-compose 

# GUI stuff
apt-get install -y gnome-tweak-tool inkscape gimp xpdf texlive-full

# texlive-full takes 4.6GB
# apt-get install -y texlive-full

# other
apt-get install -y openjdk-11-jdk gnupg2 vim-python-jedi apt-transport-https p7zip-full 



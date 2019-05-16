#!/bin/sh -e

apt-get update
apt-get upgrade -y

# devel tools
apt-get install -y git build-essential maven

# net tools
apt-get install -y wireshark nmap tcpdump minicom net-tools tcptraceroute netcat telnet tcptrace

# virtualization
apt-get install -y ansible docker.io docker-compose 

# GUI stuff
apt-get install -y gnome-tweak-tool inkscape gimp xpdf texlive-full

# other
apt-get install -y openjdk-11-jdk gnupg2 vim-python-jedi python-pip apt-transport-https p7zip-full 



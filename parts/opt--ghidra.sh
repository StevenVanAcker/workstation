#!/bin/sh -e

# DESCRIPTION: Ghidra reverse engineering tool from NSA



if [ -e /opt/ghidra ];
then
	# already installed
	exit 0
fi

apt-get install -y unzip

base="https://github.com/NationalSecurityAgency/ghidra/releases"
tmpfile=$(mktemp --suffix .zip)
abspath=$(lynx --dump "$base" |grep -oP 'https://.*.zip$'|head -1)

echo "Downloading from $abspath"
curl -Lo $tmpfile "$abspath"

cd /opt
unzip $tmpfile
ln -s ghidra_* ghidra

rm -f $tmpfile

echo "export PATH=\"/opt/ghidra/:\$PATH\"" >> /etc/bash.bashrc

cat > /usr/share/applications/ghidra.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Ghidra
Comment=Reverse Engineering Tool by the NSA
Icon=/opt/ghidra/docs/images/GHIDRA_1.png
Exec=/opt/ghidra/ghidraRun
Terminal=false
EOF


mkdir -p /opt/ghidra/Ghidra/Processors/ARM/data/manuals
curl -Lo /opt/ghidra/Ghidra/Processors/ARM/data/manuals/Armv7AR_errata.pdf https://www.cs.utexas.edu/~simon/378/resources/ARMv7-AR_TRM.pdf


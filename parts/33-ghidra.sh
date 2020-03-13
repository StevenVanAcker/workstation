#!/bin/sh -e

if [ "$INSTALL_GHIDRA" = "no" ];
then
    exit 0
fi

if [ -e /opt/ghidra ];
then
	# already installed
	exit 0
fi

base="https://ghidra-sre.org"
tmpfile=$(tempfile -s zip)

relpath=$(curl -s "$base" |grep -oP '"[^"]*zip"'|tr -d '"')
abspath="$base/$relpath"

curl -o $tmpfile "$abspath"

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
curl -o /opt/ghidra/Ghidra/Processors/ARM/data/manuals/Armv7AR_errata.pdf https://www.cs.utexas.edu/~simon/378/resources/ARMv7-AR_TRM.pdf



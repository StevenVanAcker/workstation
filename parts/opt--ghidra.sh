#!/bin/sh -e

# DESCRIPTION: Ghidra reverse engineering tool from NSA

export MAINUSER=$(id -nu 1000)


if [ -e /opt/ghidra ];
then
	# already installed
	exit 0
fi

base="https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
tmpfile=$(mktemp --suffix .zip)
abspath=$(curl -s "$base"|jq -r .assets[0].browser_download_url)


echo "Downloading from $abspath"
curl -Lo $tmpfile "$abspath"

cd /opt
unzip $tmpfile
ln -s ghidra_* ghidra
chown -R $MAINUSER: ghidra*
patch /opt/ghidra/Ghidra/Processors/V850/data/languages/Instructions/Special.sinc <<EOF
--- Special.sinc	2023-11-28 15:18:11.082571251 +0100
+++ Special-patched.sinc	2023-11-28 15:17:37.502949826 +0100
@@ -73,6 +73,13 @@
 	call adr32;
 }
 
+# JARL [reg1], reg3 - 11000111111RRRRR|WWWWW00101100000
+:jarl [R0004] R2731 is op0515=0x63F & R0004; op1626=0x160 & R2731
+{
+	R2731 = inst_next;
+	call [R0004];
+}
+
 # JMP [reg1] - 00000000011RRRRR
 :jmp [R0004] is op0515=0x03 & R0004 & op0004=0x1F
 {
EOF

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



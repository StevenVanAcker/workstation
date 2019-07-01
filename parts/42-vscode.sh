#!/bin/sh -e

tf=$(tempfile)
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $tf
install -o root -g root -m 644 $tf /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list


apt-get install -y apt-transport-https
apt-get update
apt-get install -y code # or code-insiders

rm -f $tf

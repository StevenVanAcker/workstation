#!/bin/sh -e

if [ "$INSTALL_VSCODE" = "no" ];
then
    exit 0
fi


tf=$(mktemp)
curl -L https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $tf
install -o root -g root -m 644 $tf /etc/apt/trusted.gpg.d/microsoft.gpg
rm -f $tf

echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list


apt-get install -y apt-transport-https
apt-get update
apt-get install -y code # or code-insiders

extensions="ms-python.python ms-vscode.cpptools eamodio.gitlens ms-azuretools.vscode-docker"

for ext in $extensions;
do
	su -c "code --force --install-extension $ext" $MAINUSER
done

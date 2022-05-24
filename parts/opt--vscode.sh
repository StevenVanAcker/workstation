#!/bin/sh -e

# DESCRIPTION: Microsoft Visual Studio Code IDE


tf=$(mktemp)
curl -L https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $tf
install -o root -g root -m 644 $tf /etc/apt/trusted.gpg.d/microsoft.gpg
rm -f $tf

echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list


apt-get install -y apt-transport-https
apt-get update
apt-get install -y code # or code-insiders

extensions="
	ms-python.python
	ms-vscode.cpptools
	eamodio.gitlens
	ms-azuretools.vscode-docker
	tht13.html-preview-vscode
	james-yu.latex-workshop
	bierner.markdown-preview-github-styles
	ms-vscode.cpptools-extension-pack

	ms-python.vscode-pylance
	ms-vscode-remote.remote-containers

	vscjava.vscode-java-debug
	vscjava.vscode-java-pack
	ms-toolsai.jupyter
	ms-toolsai.jupyter-keymap
	ms-toolsai.jupyter-renderers
	redhat.java
	vscjava.vscode-maven
	vscjava.vscode-java-dependency
	vscjava.vscode-java-test
	visualstudioexptteam.vscodeintellicode
	"

for ext in $extensions;
do
	echo "### Installing VSCode extension $ext"
	su -c "code --force --install-extension $ext" $MAINUSER
done

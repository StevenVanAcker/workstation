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
	alex079.vscode-avr-helper
	bierner.markdown-preview-github-styles
	cschlosser.doxdocgen
	eamodio.gitlens
	efanzh.graphviz-preview
	hashicorp.terraform
	james-yu.latex-workshop
	jeff-hykin.better-cpp-syntax
	joaompinto.vscode-graphviz
	josetr.cmake-language-support-vscode
	ms-azuretools.vscode-docker
	ms-dotnettools.vscode-dotnet-runtime
	ms-python.isort
	ms-python.python
	ms-python.vscode-pylance
	ms-toolsai.jupyter
	ms-toolsai.jupyter-keymap
	ms-toolsai.jupyter-renderers
	ms-toolsai.vscode-jupyter-cell-tags
	ms-toolsai.vscode-jupyter-slideshow
	ms-vscode.cmake-tools
	ms-vscode.cpptools
	ms-vscode.cpptools-extension-pack
	ms-vscode.cpptools-themes
	ms-vscode.remote-explorer
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-ssh-edit
	ms-vscode-remote.remote-wsl
	redhat.java
	tht13.html-preview-vscode
	twxs.cmake
	valentjn.vscode-ltex
	visualstudioexptteam.intellicode-api-usage-examples
	visualstudioexptteam.vscodeintellicode
	vscjava.vscode-java-debug
	vscjava.vscode-java-dependency
	vscjava.vscode-java-pack
	vscjava.vscode-java-test
	vscjava.vscode-maven
	"

for ext in $extensions;
do
	echo "### Installing VSCode extension $ext"
	su -c "code --force --install-extension $ext" $MAINUSER
done


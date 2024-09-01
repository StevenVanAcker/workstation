#!/bin/sh -e

# DESCRIPTION: Microsoft Visual Studio Code IDE


tf=$(mktemp)
curl -L https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $tf
install -o root -g root -m 644 $tf /etc/apt/trusted.gpg.d/microsoft.gpg
rm -f $tf

echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

yes | aptdcon --hide-terminal --install="apt-transport-https"
yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="code"

extensions="
	alex079.vscode-avr-helper
	bierner.markdown-preview-github-styles
	cschlosser.doxdocgen
	dbaeumer.vscode-eslint
	dsznajder.es7-react-js-snippets
	eamodio.gitlens
	efanzh.graphviz-preview
	esbenp.prettier-vscode
	github.copilot
	github.copilot-chat
	hashicorp.terraform
	james-yu.latex-workshop
	jeff-hykin.better-cpp-syntax
	joaompinto.vscode-graphviz
	josetr.cmake-language-support-vscode
	ms-azuretools.vscode-docker
	ms-dotnettools.vscode-dotnet-runtime
	ms-python.black-formatter
	ms-python.autopep8
	ms-python.debugpy
	ms-python.flake8
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
	ms-vscode.makefile-tools
	ms-vscode.remote-explorer
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-ssh-edit
	ms-vscode-remote.remote-wsl
	redhat.java
	twxs.cmake
	valentjn.vscode-ltex
	visualstudioexptteam.intellicode-api-usage-examples
	visualstudioexptteam.vscodeintellicode
	vscjava.vscode-gradle
	vscjava.vscode-java-debug
	vscjava.vscode-java-dependency
	vscjava.vscode-java-pack
	vscjava.vscode-java-test
	vscjava.vscode-maven
	"

for ext in $extensions;
do
	echo "### Installing VSCode extension $ext"
	su -c "code --force --install-extension $ext" $MAINUSER || true
done


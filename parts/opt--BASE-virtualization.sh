#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

export MAINUSER=$(id -nu 1000)

# accept virtualbox-ext-pack license
echo virtualbox-ext-pack virtualbox-ext-pack/license select true | debconf-set-selections

# setup terraform repo
echo ">>> Adding terraform package repository"
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/terraform-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/terraform-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/terraform.list
apt-get update

echo ">>> Installing packages"
apt-get install -y 	docker.io \
					docker-compose \
					dosbox \
					qemu-user-static \
					qemu-system \
					gdb-avr \
					awscli \
					packer \
					virtualbox \
					virtualbox-ext-pack \
					terraform \
					ansible

# for USB access
echo ">>> Adding $MAINUSER to vboxusers"
adduser $MAINUSER vboxusers

# install azure-cli
echo ">>> Installing azure-cli"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install vagrant with some extensions. Specifically, AWS integration.
dpkg -l vagrant && echo "==> Vagrant already installed." && exit 0

apt-get install -y gnupg lsb-release software-properties-common
ubuntuver=$(lsb_release -cs)
echo ">>> Trying to install vagrant on Ubuntu $ubuntuver"

if true; #[ "$ubuntuver" != "jammy" ];
then
	curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
	apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	apt-get update && apt-get install -y vagrant

	echo "==> Installing vagrant plugins"
	# vagrant plugin install vagrant-libvirt
	vagrant plugin install vagrant-host-shell
	#vagrant plugin install vagrant-aws # broken on 2020-06-09 because of fricking ruby
	vagrant plugin install vagrant-winrm

	cat > /dev/null <<EOF
~/.vagrant.d/Vagrantfile
EOF

fi

#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

export MAINUSER=$(id -nu 1000)

apt-get install -y 	docker.io \
					docker-compose \
					dosbox \
					qemu-user-static \
					qemu-system \
					gdb-avr \
					awscli \
					packer \
					virtualbox \
					virtualbox-ext-pack

# for USB access
adduser $MAINUSER vboxusers

# Install vagrant with some extensions. Specifically, AWS integration.
dpkg -l vagrant && echo "==> Vagrant already installed." && exit 0

apt-get install -y gnupg lsb-release software-properties-common
ubuntuver=$(lsb_release -cs)
echo ">>> Trying to install vagrant on Ubuntu $ubuntuver"

if [ "$ubuntuver" != "jammy" ];
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

#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

apt-get install -y 	docker.io \
					docker-compose \
					dosbox \
					qemu-user-static \
					qemu-system \
					gdb-avr \
					awscli \
					packer \
					virtualbox

# Install vagrant with some extensions. Specifically, AWS integration.
dpkg -l vagrant && echo "==> Vagrant already installed." && exit 0

ubuntuver=$(lsb_release -cs)

echo ">>> Trying to install vagrant on Ubuntu $ubuntuver"

apt-get install -y gnupg lsb-release software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install -y vagrant

echo "==> Installing vagrant plugins"
# vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-host-shell
#vagrant plugin install vagrant-aws # broken on 2020-06-09 because of fricking ruby
vagrant plugin install vagrant-winrm

cat > /dev/null <<EOF
~/.vagrant.d/Vagrantfile
EOF


#!/bin/sh -e

# DESCRIPTION: Hashicorp Vagrant VM deployment environment


# Install vagrant with some extensions. Specifically, AWS integration.

dpkg -l vagrant && echo "==> Vagrant already installed." && exit 0

ubuntuver=$(lsb_release -cs)

if [ "$ubuntuver" = "impish" ];
then
	echo "Broken on impish..."
	exit 0
fi

echo ">>> Trying to install vagrant on Ubuntu $ubuntuver"

apt-get install -y gnupg lsb-release software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install -y vagrant

if false;
then
	echo "==> Installing some dependencies"
	apt-get install -y curl qemu libvirt-daemon libvirt-clients ebtables dnsmasq libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt

	echo "==> Downloading and installing vagrant"
	tmpdir=$(mktemp -d)
	url=$(curl -Ls https://www.vagrantup.com/downloads.html | grep -oP "http[^\"]+i686.deb")

	curl -Lo $tmpdir/vagrant.deb "$url"
	dpkg -i $tmpdir/vagrant.deb
	rm -rf $tmpdir

	echo "==> Installing build dependencies"
	sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"
	apt-get update
	apt-get build-dep -y vagrant ruby-libvirt
fi

echo "==> Installing vagrant plugins"
# vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-host-shell
#vagrant plugin install vagrant-aws # broken on 2020-06-09 because of fricking ruby
vagrant plugin install vagrant-winrm

cat > /dev/null <<EOF
~/.vagrant.d/Vagrantfile
EOF


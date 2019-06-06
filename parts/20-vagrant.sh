#!/bin/sh -e

# Install vagrant with some extensions. Specifically, AWS integration.

dpkg -l vagrant && echo "==> Vagrant already installed." && exit 0

echo "==> Installing some dependencies"
apt-get install -y lynx qemu libvirt-daemon libvirt-clients ebtables dnsmasq libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt

echo "==> Downloading and installing vagrant"
tmpdir=$(mktemp -d)
url=$(lynx -dump https://www.vagrantup.com/downloads.html|grep x86_64.deb | awk '{print $2}')
curl -o $tmpdir/vagrant.deb "$url"
dpkg -i $tmpdir/vagrant.deb
rm -rf $tmpdir

echo "==> Installing build dependencies"
sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"
apt-get update
apt-get build-dep -y vagrant ruby-libvirt

echo "==> Installing vagrant plugins"
# vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-host-shell
vagrant plugin install vagrant-aws
vagrant plugin install vagrant-winrm

cat > /dev/null <<EOF
~/.vagrant.d/Vagrantfile
EOF


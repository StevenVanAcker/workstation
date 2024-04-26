#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

export MAINUSER=$(id -nu 1000)

# accept virtualbox-ext-pack license
echo virtualbox-ext-pack virtualbox-ext-pack/license select true | debconf-set-selections

# setup hashicorp repo
RELEASE=none
for rel in $(distro-info --supported | tac);
do
	echo -n ">>> Checking whether hashicorp supports release $rel: "
	if curl --output /dev/null --silent --head --fail https://apt.releases.hashicorp.com/dists/$rel/Release;
	then
		echo "yes."
		export RELEASE=$rel
	else
		echo "no."
	fi
done

if [ "$RELEASE" = "none" ];
then
	echo "!!! Hashicorp is not supported on any release"
	false
fi

echo ">>> Adding hashicorp package repository"
rm -f /usr/share/keyrings/hashicorp-archive-keyring.gpg
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $RELEASE main" > /etc/apt/sources.list.d/hashicorp.list

yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="terraform packer"

echo ">>> Installing packages"
PACKAGES="docker.io \
		docker-compose \
		dosbox \
		qemu-user-static \
		qemu-system \
		gdb-avr \
		awscli \
		virtualbox \
		virtualbox-qt \
		virtualbox-ext-pack \
		ansible \
		libvirt-daemon-system \
		wine"

yes | aptdcon --hide-terminal --install="$PACKAGES"

# for USB access
echo ">>> Adding $MAINUSER to vboxusers"
adduser $MAINUSER vboxusers

# install azure-cli
echo ">>> Installing azure-cli"
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install vagrant with some extensions. Specifically, AWS integration.
echo ">>> Checking vagrant"
dpkg -s vagrant && echo "==> Vagrant already installed." && exit 0

echo ">>> Installing gnupg and friends"
yes | aptdcon --hide-terminal --install="gnupg lsb-release software-properties-common"

echo ">>> Trying to install vagrant on Ubuntu $RELEASE"


yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="vagrant vagrant-libvirt"

echo "==> Installing vagrant plugins"
vagrant plugin install vagrant-host-shell
#vagrant plugin install vagrant-aws # broken on 2020-06-09 because of fricking ruby
vagrant plugin install vagrant-winrm

cat > /dev/null <<EOF
~/.vagrant.d/Vagrantfile
EOF

#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

export MAINUSER=$(id -nu 1000)

# accept virtualbox-ext-pack license
echo virtualbox-ext-pack virtualbox-ext-pack/license select true | debconf-set-selections

# Install OpenTofu as an alternative to terraform
echo ">>> Installing OpenTofu"
tmpfile=$(mktemp)
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o $tmpfile
chmod +x $tmpfile
$tmpfile --install-method deb
rm -f $tmpfile

# Test tofu
echo ">>> Testing tofu"
tofu -version

echo ">>> Installing packages"
PACKAGES="docker.io \
		docker-compose \
		dosbox \
		qemu-user-static \
		qemu-system \
		gdb-avr \
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

# install awscli but ignore colorama (which is already installed)
pip3 install awscli --ignore-installed colorama
echo ">>> Testing awscli"
aws --version

# install azure-cli
echo ">>> Installing azure-cli"
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
# test azure-cli
echo ">>> Testing azure-cli"
az version

# Install vagrant
if which vagrant;
then
	echo "==> Vagrant already installed."
else
	echo ">>> Installing libfuse2 for vagrant"
	release=$(lsb_release -cs)
	if [ "$release" = "noble" ];
	then
		echo ">>> installing libfuse2t64"
		yes | aptdcon --hide-terminal --install="libfuse2t64"
	else
		echo ">>> Installing libfuse2"
		yes | aptdcon --hide-terminal --install="libfuse2"
	fi
	echo ">>> Installing vagrant"
	base=https://developer.hashicorp.com/vagrant/install
	url=$(lynx -dump "$base" | grep -oP "https?://.*linux_amd64.zip$")
	tmpfile=$(mktemp --suffix .zip)
	tmpdir=$(mktemp -d)
	echo "==> Downloading latest vagrant to $tmpfile from $url"
	curl -Lo $tmpfile "$url"
	echo "==> Unpacking..."
	cd $tmpdir
	unzip $tmpfile
	find $tmpdir -ls
	mv $tmpdir/vagrant /usr/local/bin
	cd /
	rm -rf $tmpfile $tmpdir
fi

# test vagrant
# echo "==> Testing vagrant"
# vagrant version
echo "==> Installing vagrant plugins"
vagrant plugin install vagrant-host-shell || true
vagrant plugin install vagrant-winrm || true

# Install packer
if which packer;
then
	echo "==> Packer already installed."
else 
	echo ">>> Installing packer"
	base=https://developer.hashicorp.com/packer/install
	url=$(lynx -dump "$base" | grep -oP "https?://.*linux_amd64.zip$")
	tmpfile=$(mktemp --suffix .zip)
	tmpdir=$(mktemp -d)
	echo "==> Downloading latest packer to $tmpfile from $url"
	curl -Lo $tmpfile "$url"
	echo "==> Unpacking..."
	cd $tmpdir
	unzip $tmpfile
	find $tmpdir -ls
	mv $tmpdir/packer /usr/local/bin
	cd /
	rm -rf $tmpfile $tmpdir
fi

# test packer
echo "==> Testing packer"
packer version

echo "==> Installing packer plugins"
packer plugins install github.com/hashicorp/vagrant
packer plugins install github.com/hashicorp/virtualbox

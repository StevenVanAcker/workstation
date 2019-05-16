#!/bin/bash -e

dpkg -l google-chrome-stable && echo "==> Chrome already installed." && exit 0

echo "==> Downloading and installing Google Chrome .deb package"
tmpdir=$(mktemp -d)
curl -o $tmpdir/google-chrome-stable_current_amd64.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb?src=0&filename=google-chrome-stable_current_amd64.deb'
dpkg -i $tmpdir/google-chrome-stable_current_amd64.deb || dpkg -l google-chrome-stable
rm -rf $tmpdir

echo "==> Updating repos and installing dependencies..."
apt-get update
apt-get -f install -y


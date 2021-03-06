#!/bin/sh -e

echo "This will install packages and configure this machine as a workstation."
echo "Sleeping 5 seconds so you can cancel..."
sleep 5

sudo apt-get update
sudo apt-get install -y git sudo
tmpdir=$(mktemp -d)
cd $tmpdir

git clone https://github.com/StevenVanAcker/workstation.git
cd workstation
sudo ./install.sh

cd /
rm -rf $tmpdir

echo "Done."

#!/bin/bash -e

# DESCRIPTION: Burp Suite Proxy installation script

tmpfile=$(mktemp /tmp/burpsuite-installer.XXXXXX.sh)

# if this script exits for whatever reason, clean up the temp file
trap "rm -f $tmpfile" EXIT

# Portswigger unfortunately does not provide a fixed URL for the latest version, so we have to scrape the list of all burpsuite versions
# and pick the highest one.
BASEURL=https://portswigger.net
STARTURL=$BASEURL/burp/releases
latest_path=$(curl -s $STARTURL|grep -oP "/burp/releases/professional-community-[^\"]+" | sort -nr | head -1)
latest=$(echo $latest_path | sed 's:.*professional-community-::' | tr "-" ".")
echo "==> Latest Burp Suite version is $latest"

# Now compose the magic download string
download_url="https://portswigger.net/burp/releases/download?product=pro&version=$latest&type=Linux"

echo "==> Downloading from $download_url to $tmpfile"
curl -L $download_url -o $tmpfile
chmod 0755 $tmpfile

s=$(sha256sum $tmpfile | awk '{print $1}')
echo "==> Downloaded file SHA256: $s"

export MAINUSER=$(id -nu 1000)
echo "==> Installing Burp Suite as user $MAINUSER"
sudo -u $MAINUSER $tmpfile

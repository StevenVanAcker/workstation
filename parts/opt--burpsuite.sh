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
latest_url=$BASEURL$latest_path
echo "==> Latest Burp Suite version is $latest at $latest_url"

# Now select the Pro edition Linux installer that is not for arm64
download_path=$(curl -s $latest_url|grep startdownload|grep Linux|grep Professional|grep -v arm64|grep -oP "href=[^>]*")
download_url=$BASEURL$(echo $download_path | sed 's/href=//g')

echo "==> Downloading from $download_url to $tmpfile"
curl -L $download_url -o $tmpfile
chmod +x $tmpfile

export MAINUSER=$(id -nu 1000)
echo "==> Installing Burp Suite as user $MAINUSER"
sudo -u $MAINUSER $tmpfile

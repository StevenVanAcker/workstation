#!/bin/bash -e

# DESCRIPTION: Burp Suite Proxy installation script

if [ -e /opt/burpsuite ];
then
	# already installed
	echo "==> Burp Suite already installed, skipping."
	echo "==> To reinstall, please remove /opt/burpsuite first."
	exit 0
fi

tmpfile=$(mktemp /tmp/burpsuite-installer.XXXXXX.jar)

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
download_url="https://portswigger.net/burp/releases/download?product=pro&version=$latest&type=Jar"

echo "==> Downloading from $download_url to $tmpfile"
curl -L $download_url -o $tmpfile

s=$(sha256sum $tmpfile | awk '{print $1}')
echo "==> Downloaded file SHA256: $s"

mkdir -p /opt/burpsuite
mv $tmpfile /opt/burpsuite/burpsuite.jar
chmod 755 /opt/burpsuite/burpsuite.jar

cat > /usr/share/applications/burpsuite.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Burp Suite Pro
Icon=/opt/burpsuite/BurpSuitePro.png
Exec=java -jar -Xmx8G -Xms8G /opt/burpsuite/burpsuite.jar
Terminal=false
EOF

HERE=$(dirname $(readlink -f $0))
cp $HERE/../files/BurpSuitePro.png /opt/burpsuite/BurpSuitePro.png
echo "==> Burp Suite installation completed."

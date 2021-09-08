#!/bin/sh -e
# DESCRIPTION: Android Studio with ADB

base="https://developer.android.com/studio"

apt-get -y install adb

if [ -e /opt/android-studio ];
then
	# already installed
	exit 0
fi

if [ "$SKIPBIGSTUFF" = "yes" ];
then
	echo "Skipping this on request"; 
	exit 0; 
fi

tmpfile=$(mktemp --suffix .tar.gz)

echo "==> Checking for latest Android Studio IDE version"
url=$(lynx -dump "$base" | grep -oP "(https?://.*-linux.tar.*)$")

echo "==> Downloading latest Android Studio IDE to $tmpfile from $url"
curl -Lo $tmpfile "$url"

echo "==> Unpacking..."
cd /opt
tar -xf $tmpfile

echo "==> Cleaning up"
rm -f $tmpfile

echo "==> Creating shortcut"
cat > /usr/share/applications/android-studio.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Android Studio
Comment=Android Studio
Icon=/opt/android-studio/bin/studio.png
Exec=/opt/android-studio/bin/studio.sh
Terminal=false
EOF

echo "==> Done."

#!/bin/bash -e

shopt -s nullglob

msgpref="Installing workstation:"

if [ -e /etc/installationprofile ];
then
	prof=$(cat /etc/installationprofile);
	export INSTALL_PROFILE=$prof
	if [ -e "profiles/$prof" ];
	then
		set -a
		. profiles/$prof
		set +a
		msgpref="Installing workstation ($prof):"
	fi
fi

showmsg() {
	echo "### $msgpref $1"
	which plymouth > /dev/null && plymouth display-message --text="$msgpref $1" || true
}

export DEBIAN_FRONTEND=noninteractive

showmsg "apt-get update"
apt-get update

export MAINUSER=$(id -nu 1000)
echo "Main user: $MAINUSER"

for i in parts/[0-9][0-9]*.sh;
do
	showmsg "Running $i"
	./$i || (echo "!!!! ERROR executing $i" && exit 1)
	echo
	echo
done

showmsg "Done."

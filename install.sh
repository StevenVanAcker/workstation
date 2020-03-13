#!/bin/bash -e

shopt -s nullglob

export msgpref="Installing workstation:"

mkdir -p /etc/xxx
touch /etc/xxx/a1

if [ -e /etc/installprofile ];
then
	export msgpref="Installing workstation ($prof?):"
	prof=$(cat /etc/installprofile);
	touch /etc/xxx/a2
	if [ -e "profiles/$prof" ];
	then
		touch /etc/xxx/a3
		set -a
		. profiles/$prof
		msgpref="Installing workstation ($prof):"
		set +a
		touch /etc/xxx/a4
	fi
fi

touch /etc/xxx/a5

showmsg() {
	echo "### $msgpref $1"
	which plymouth && plymouth display-message --text="$msgpref $1" || true
}

export DEBIAN_FRONTEND=noninteractive

showmsg "apt-get update"
apt-get update
showmsg "apt-get install"
apt-get install -y virt-what


export MAINUSER=$(getent passwd 1000 | cut -d: -f1)
echo "Main user: $MAINUSER"

export INSIDEVM=yes
if [ "" = "$(virt-what|head)" ]; 
then 
	export INSIDEVM=no
fi

showmsg "Running inside VM: $INSIDEVM"

for i in parts/[0-9][0-9]*.sh;
do
	showmsg "Running $i"
	./$i || (echo "!!!! ERROR executing $i" && exit 1)
	echo
	echo
done

showmsg "Done."

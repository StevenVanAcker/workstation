#!/bin/bash -e

shopt -s nullglob

msgpref="Installing workstation:"

showmsg() {
	echo "### $msgpref $1"
	which plymouth && plymouth display-message --text="$msgpref $1"
}

export DEBIAN_FRONTEND=noninteractive

showmsg "apt-get update"
apt-get update
showmsg "apt-get install"
apt-get install -y virt-what

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

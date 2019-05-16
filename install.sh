#!/bin/bash -e

shopt -s nullglob

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y virt-what

export INSIDEVM=yes
if [ "" = "$(virt-what|head)" ]; 
then 
	export INSIDEVM=no
fi

echo "=> Running inside VM: $INSIDEVM"

for i in parts/[0-9][0-9]*.sh;
do
	echo "# Running $i"
	./$i || (echo "!!!! ERROR executing $i" && exit 1)
	echo
	echo
done

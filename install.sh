#!/bin/bash -e

shopt -s nullglob

export DEBIAN_FRONTEND=noninteractive

for i in parts/[0-9][0-9]*.sh;
do
	echo "# Running $i"
	./$i || (echo "!!!! ERROR executing $i" && exit 1)
	echo
	echo
done

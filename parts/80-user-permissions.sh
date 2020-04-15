#!/bin/sh -e

for group in docker kvm;
do
	getent group $group > /dev/null && adduser $MAINUSER $group
done

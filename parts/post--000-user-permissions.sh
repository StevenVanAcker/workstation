#!/bin/sh -e

for group in docker kvm libvirt;
do
	getent group $group > /dev/null && adduser $MAINUSER $group || true
done

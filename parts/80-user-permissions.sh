#!/bin/sh -e

for group in docker kvm;
do
	getent groups $group > /dev/null && adduser $MAINUSER $group
done

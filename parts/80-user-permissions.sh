#!/bin/sh -e

for group in docker kvm;
do
	adduser $MAINUSER $group
done

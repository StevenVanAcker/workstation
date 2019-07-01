#!/bin/sh -e

user=$(getent passwd 1000 | cut -d: -f1)

for group in docker kvm;
do
	adduser $user $group
done

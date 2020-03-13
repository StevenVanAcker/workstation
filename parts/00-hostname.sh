#!/bin/sh -e

# Set the hostname

if [ "$INSTALLATION_HOSTNAME" = "" ];
then
	if [ "$INSTALLATION_PROFILE" = "" ];
	then
		exit 1
	else
		hostnamectl set-hostname "$INSTALLATION_PROFILE"
	fi
else
	hostnamectl set-hostname "$INSTALLATION_HOSTNAME"
fi


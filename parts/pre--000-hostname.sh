#!/bin/sh -e

# Set the hostname

if [ "$INSTALL_HOSTNAME" = "" ];
then
	if [ "$INSTALL_PROFILE" = "" ];
	then
		exit 1
	else
		hostnamectl set-hostname "$INSTALL_PROFILE"
	fi
else
	hostnamectl set-hostname "$INSTALL_HOSTNAME"
fi


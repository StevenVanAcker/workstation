#!/bin/sh -e

# Select ALL packages
echo "ALL" > /etc/hostname

dbus-daemon --system

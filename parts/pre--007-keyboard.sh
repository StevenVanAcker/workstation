#!/bin/sh -e

# set both US and SE keyboards
export MAINUSER=$(id -nu 1000)
su -c "dbus-launch --exit-with-session gsettings set org.gnome.desktop.input-sources sources \"[('xkb', 'us'), ('xkb', 'se')]\"" $MAINUSER

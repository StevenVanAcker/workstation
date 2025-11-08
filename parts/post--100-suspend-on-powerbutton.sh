#!/bin/bash -e

HERE=$(dirname $(readlink -f $0))

mkdir -p /etc/dconf/db/local.d
cp $HERE/../files/dconf-suspend-on-powerbutton.conf /etc/dconf/db/local.d/00-suspend-on-powerbutton
dconf update

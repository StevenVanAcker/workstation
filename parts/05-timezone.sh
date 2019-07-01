#!/bin/sh -e

# Change the timezone to Europe/Stockholm
# This setting can be configured through preseeding as well, but that seems to
# be buggy: because of the changed timezone in preseeing, gnome terminal (or
# xwayland?) stops working for some reason.

echo "Europe/Stockholm" > /etc/timezone

timedatectl set-timezone Europe/Stockholm

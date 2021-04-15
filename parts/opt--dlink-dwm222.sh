#!/bin/sh -e

# DESCRIPTION: D-Link DWM-222 4G LTE USB Adapter tools and drivers

# Setting up tools to use D-Link DWM-222 4G LTE USB Adapter
# http://blog.petrilopia.net/linux/raspberry-pi-and-d-link-dwm-222/

# there are 2 ways to connect: via PPP or via QMI wwan
apt-get install -y wvdial libqmi-utils

# (PPP) start with:
#   wvdial
cat > /etc/wvdial.conf <<EOF
[Dialer defaults]
Modem = /dev/ttyUSB1
Init = AT+CGDCONT=1,"IP","internet"
Phone = *99#
Stupid Mode = 1
Username = ""
Password = ""
EOF

# (QMI wwan) start with:
#    qmi-network /dev/cdc-wdm1 start
#    dhclient wwp0s20u2i4
cat > /etc/qmi-network.conf <<EOF
APN=internet
APN_USER=
APN_PASS=
EOF

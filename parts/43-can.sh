#!/bin/sh -e

apt-get install -y can-utils

cat > /etc/network/interfaces.d/can0.cfg <<EOF
auto can0
iface can0 inet manual
        pre-up /sbin/ip link set \$IFACE type can bitrate 500000 on
        up /sbin/ifconfig \$IFACE up
        down /sbin/ifconfig \$IFACE down
EOF


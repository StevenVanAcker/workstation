#!/bin/sh -e
# DESCRIPTION: CAN tools

yes | aptdcon --hide-terminal --install="can-utils"

# FIXME: switch to netplan
# https://wiki.ubuntu.com/MigratingToNetplan
# https://netplan.io/

if false;
then
cat > /etc/network/interfaces.d/can0.cfg <<EOF
allow-hotplug can0
iface can0 can static
    bitrate 500000
    up /sbin/ip link set \$IFACE down
    up /sbin/ip link set \$IFACE type can bitrate 500000
    up /sbin/ip link set \$IFACE up
EOF

grep -q "^source-directory /etc/network/interfaces.d" /etc/network/interfaces || ( echo "source-directory /etc/network/interfaces.d" >> /etc/network/interfaces )

/etc/init.d/networking reload
fi

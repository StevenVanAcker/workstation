#!/bin/sh -e

# DESCRIPTION: Minicom text-based modem control and terminal emulator

apt-get install -y minicom

cat > /etc/minicom/minirc.dfl <<EOF
# Machine-generated file - use "minicom -s" to change parameters.
pu port             /dev/ttyUSB0
pu rtscts           No 
EOF

adduser $MAINUSER dialout

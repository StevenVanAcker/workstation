#!/bin/sh -e

if [ "$INSTALL_MINICOM" = "no" ];
then
    exit 0
fi


apt-get install -y minicom

cat > /etc/minicom/minirc.dfl <<EOF
# Machine-generated file - use "minicom -s" to change parameters.
pu port             /dev/ttyUSB0
pu rtscts           No 
EOF

adduser $MAINUSER dialout

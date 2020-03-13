#!/bin/sh -e

if [ "$INSTALL_GNURADIO" = "no" ];
then
    exit 0
fi


apt-get install -y gnuradio gr-osmosdr


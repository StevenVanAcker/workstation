#!/bin/sh -e

# DESCRIPTION: GNU Radio

yes | aptdcon --hide-terminal --install="gnuradio gr-osmosdr"
# WARNING: uhd-host uses python2


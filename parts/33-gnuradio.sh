#!/bin/sh -e

# https://www.gnuradio.org/blog/2016-06-19-pybombs-the-what-the-how-and-the-why/
pip install pybombs
pybombs recipes add -f gr-recipes git+https://github.com/gnuradio/gr-recipes.git

mkdir -p /opt/gnuradio
pybombs prefix init -a default /opt/gnuradio/default/ -R gnuradio-default

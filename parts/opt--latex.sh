#!/bin/sh -e
# DESCRIPTION: Texlive and latexmk

if [ -e /skipbigstuff ];
then
	echo "Skipping this on request"; 
	exit 0; 
fi

apt-get install -y texlive-full latexmk


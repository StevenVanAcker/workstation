#!/bin/sh -e

cd $(mktemp -d)
curl -L -o entry.sh https://bit.ly/svaworkstation
chmod +x entry.sh
./entry.sh


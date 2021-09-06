#!/bin/sh -e

# DESCRIPTION: Steam, the ultimate online game platform

dpkg -l steam && echo "==> Steam already installed." && exit 0

dpkg --add-architecture i386
apt-get update && apt-get install -y steam


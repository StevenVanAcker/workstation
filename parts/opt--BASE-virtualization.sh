#!/bin/sh -e
# DESCRIPTION: Virtualisation tools

#virtualbox
#vagrant

apt-get install -y 	docker.io \
					docker-compose \
					dosbox \
					qemu-user-static \
					qemu-system \
					awscli \
					packer


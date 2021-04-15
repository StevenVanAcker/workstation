#!/bin/sh -e

# use explicit DNS server in Docker configuration

cat > /etc/docker/daemon.json <<EOF
{ "dns": ["8.8.8.8"] }
EOF
systemctl restart docker

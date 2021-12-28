#!/bin/sh -e

# use explicit DNS server in Docker configuration

mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{ "dns": ["8.8.8.8"] }
EOF
systemctl restart docker || echo "Failed but that's ok..."

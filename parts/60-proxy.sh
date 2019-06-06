#!/bin/bash

# Setup an HTTP/HTTPS proxy and route all traffic through it by default.  Some
# corporate networks require the use of an HTTP proxy, and having one set up by
# default will allow proxy chaining to this corporate proxy when we want it.

# setup tinyproxy on 127.0.0.1:8080
apt-get install -y tinyproxy socat

cat > /etc/tinyproxy/tinyproxy.conf.vanilla <<EOF
User tinyproxy
Group tinyproxy
Port 8080
Listen 127.0.0.1
Timeout 600
DefaultErrorFile "/usr/share/tinyproxy/default.html"
StatFile "/usr/share/tinyproxy/stats.html"
LogFile "/var/log/tinyproxy/tinyproxy.log"
PidFile "/run/tinyproxy/tinyproxy.pid"

MaxClients 100
MinSpareServers 5
MaxSpareServers 20
StartServers 10
MaxRequestsPerChild 0
Allow 127.0.0.1
EOF
rm -f /etc/tinyproxy/tinyproxy.conf
ln -s /etc/tinyproxy/tinyproxy.conf.vanilla /etc/tinyproxy/tinyproxy.conf
/etc/init.d/tinyproxy restart

# Configure ssh to make github and bitbucket access go through the proxy
cat > /etc/ssh/ssh_config <<EOF
Host *
    SendEnv LANG LC_*
    HashKnownHosts yes
    GSSAPIAuthentication yes

host github.com
    user git
    hostname ssh.github.com
    port 443
    proxycommand socat - PROXY:127.0.0.1:%h:%p,proxyport=8080

host bitbucket.org
    user git
    hostname altssh.bitbucket.org
    port 443
    proxycommand socat - PROXY:127.0.0.1:%h:%p,proxyport=8080
EOF

# apt proxy
# https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-the-proxy-for-apt-for-ubuntu-18-04/
# vagrant proxy
# https://stackoverflow.com/questions/19872591/how-to-use-vagrant-in-a-proxy-environment
# docker

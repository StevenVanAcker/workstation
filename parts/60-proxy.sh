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

cat >>/etc/environment <<EOF
http_proxy="http://127.0.0.1:8080/"
https_proxy="http://127.0.0.1:8080/"
ftp_proxy="http://127.0.0.1:8080/"
no_proxy="localhost,127.0.0.1,::1
EOF

# patch gnome-shell defaults to set proxy
tmpfile=$(mktemp)
cat > $tmpfile <<EOF
diff --git a/org.gnome.system.proxy.gschema.xml.orig b/org.gnome.system.proxy.gschema.xml
index edaf0aa..e8a6942 100644
--- a/org.gnome.system.proxy.gschema.xml.orig
+++ b/org.gnome.system.proxy.gschema.xml
@@ -6,7 +6,7 @@
     <child name="ftp" schema="org.gnome.system.proxy.ftp"/>
     <child name="socks" schema="org.gnome.system.proxy.socks"/>
     <key name="mode" enum="org.gnome.desktop.GDesktopProxyMode">
-      <default>'none'</default>
+      <default>'manual'</default>
       <summary>Proxy configuration mode</summary>
       <description>
         Select the proxy configuration mode. Supported values are “none”,
@@ -69,7 +69,7 @@
       </description>
     </key>
     <key name="host" type="s">
-      <default>''</default>
+      <default>'127.0.0.1'</default>
       <summary>HTTP proxy host name</summary>
       <description>
         The machine name to proxy HTTP through.
@@ -115,7 +115,7 @@
   </schema>
   <schema id="org.gnome.system.proxy.https" path="/system/proxy/https/">
     <key name="host" type="s">
-      <default>''</default>
+      <default>'127.0.0.1'</default>
       <summary>Secure HTTP proxy host name</summary>
       <description>
         The machine name to proxy secure HTTP through.
@@ -123,7 +123,7 @@
     </key>
     <key name="port" type="i">
       <range min="0" max="65535"/>
-      <default>0</default>
+      <default>8080</default>
       <summary>Secure HTTP proxy port</summary>
       <description>
         The port on the machine defined by “/system/proxy/https/host” that you
@@ -133,7 +133,7 @@
   </schema>
   <schema id="org.gnome.system.proxy.ftp" path="/system/proxy/ftp/">
     <key name="host" type="s">
-      <default>''</default>
+      <default>'127.0.0.1'</default>
       <summary>FTP proxy host name</summary>
       <description>
         The machine name to proxy FTP through.
@@ -141,7 +141,7 @@
     </key>
     <key name="port" type="i">
       <range min="0" max="65535"/>
-      <default>0</default>
+      <default>8080</default>
       <summary>FTP proxy port</summary>
       <description>
         The port on the machine defined by “/system/proxy/ftp/host” that you
EOF

patch /usr/share/glib-2.0/schemas/org.gnome.system.proxy.gschema.xml $tmpfile
glib-compile-schemas /usr/share/glib-2.0/schemas
rm -f $tmpfile


# apt proxy
# https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-the-proxy-for-apt-for-ubuntu-18-04/
# vagrant proxy
# https://stackoverflow.com/questions/19872591/how-to-use-vagrant-in-a-proxy-environment
# docker

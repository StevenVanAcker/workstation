#!/bin/bash -e

# configure desktop favorites

mkdir -p /etc/dconf/profile /etc/dconf/db/local.d /etc/dconf/db/local.db/locks

cat > /etc/dconf/profile/user <<EOF
user-db:user
system-db:local
EOF

cat > /etc/dconf/db/local.d/00-favorite-apps <<EOF
[org/gnome/shell]
favorite-apps = ['google-chrome.desktop', 'org.gnome.Terminal.desktop']
EOF

cat > /etc/dconf/db/local.db/locks/favorite-apps <<EOF
/org/gnome/shell/favorite-apps
EOF

dconf update

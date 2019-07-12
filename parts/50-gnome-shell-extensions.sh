#!/bin/sh -e

# Install gnome tweak tool so we can install a gnome shell extension called
# quicktoggler. This extension allows us to easily run scripts from the
# gnome-shell, from a dropdown menu.

apt-get install -y gnome-tweak-tool git jq

# install quicktoggle as user
su $MAINUSER <<EOF
mkdir -p ~/.local/share/gnome-shell/extensions
mkdir -p ~/Projects.git
cd ~/Projects.git
git clone https://github.com/Shihira/gnome-extension-quicktoggler.git
cd gnome-extension-quicktoggler/quicktoggler@shihira.github.com
make install
EOF

# patch gnome-shell defaults to load this extension by default
tmpfile=$(mktemp)
cat > $tmpfile <<EOF
--- org.gnome.shell.gschema.xml.orig	2019-06-05 16:53:01.046462124 -0400
+++ org.gnome.shell.gschema.xml	2019-06-05 16:54:27.587791474 -0400
@@ -12,7 +12,7 @@
       </description>
     </key>
     <key name="enabled-extensions" type="as">
-      <default>[]</default>
+      <default>['quicktoggler@shihira.github.com']</default>
       <summary>UUIDs of extensions to enable</summary>
       <description>
         GNOME Shell extensions have a UUID property; this key lists extensions
EOF

patch /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.xml $tmpfile
glib-compile-schemas /usr/share/glib-2.0/schemas
rm -f $tmpfile


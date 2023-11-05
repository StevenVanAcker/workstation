#!/bin/sh -e

# DESCRIPTION: Yubikey

export MAINUSER=$(id -nu 1000)
export MAINHOME=$(getent passwd $MAINUSER| cut -d: -f 6)


# Following https://developers.yubico.com/PGP/SSH_authentication/

apt-get install -y \
	yubikey-manager \
	gnupg pcscd scdaemon


mkdir -p $MAINHOME/.gnupg
cat > $MAINHOME/.gnupg/scdaemon.conf <<'EOF'
disable-ccid
pcsc-driver /usr/lib/x86_64-linux-gnu/libpcsclite.so.1
card-timeout 1

# Always try to use yubikey as the first reader
# even when other smart card readers are connected
# Name of the reader can be found using the pcsc_scan command
# If you have problems with gpg not recognizing the Yubikey
# then make sure that the string here matches exacly pcsc_scan
# command output. Also check journalctl -f for errors.
reader-port Yubico YubiKey
EOF

cat > $MAINHOME/.gnupg/gpg.conf <<'EOF'
trust-model tofu+pgp
EOF

mkdir -p $MAINHOME/.config/autostart
mkdir -p $MAINHOME/.config/environment.d

# FIXME: the following line may not work
# cp /etc/xdg/autostart/gnome-keyring-ssh.desktop $MAINHOME/.config/autostart
echo "Hidden=true" >> $MAINHOME/.config/autostart/gnome-keyring-ssh.desktop

cat > $MAINHOME/.config/environment.d/99-gpg-agent_ssh.conf <<'EOF'
SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh
EOF

chown -R $MAINUSER: $MAINHOME/

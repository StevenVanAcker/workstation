#!/bin/sh -e

apt-get update
apt-get install -y curl sudo aptdaemon

# default user
if id -u 1000; then 
	u=$(id -nu 1000)
	echo "UID 1000 already taken by user $u, removing."
	userdel -f -r $u
fi

adduser -u 1000 --gecos "Steven Van Acker" --disabled-password deepstar

# create some mock commands
for cmd in hostnamectl timedatectl dconf; do
	if [ ! -e /usr/sbin/$cmd ]; then
		cat > /usr/sbin/$cmd <<EOF
#!/bin/sh -e

echo "Invoking fake $cmd \$*"
exit 0
EOF
		chmod +x /usr/sbin/$cmd
	fi
done


if ! which zenity; then
	cat > /usr/sbin/zenity <<EOF
#!/bin/sh -e

f=\$(mktemp)
cat > \$f
(
echo
echo
echo
echo "Invoking fake zenity and selecting all on:"
cat \$f
echo
echo
) 1>&2
cat \$f | awk 'NR % 3 == 2'
rm -f \$f
EOF
	chmod +x /usr/sbin/zenity
fi

# start dbus-daemon so aptdcon works
mkdir -p /run/dbus/

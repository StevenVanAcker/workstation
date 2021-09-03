#!/bin/sh -e

apt-get update
apt-get install -y curl sudo 

# TODO remove this
apt-get install -y vim

# default user
adduser -u 1000 --gecos "Steven Van Acker" --disabled-password deepstar

# create hostnamectl

cat > /usr/sbin/hostnamectl <<EOF
#!/bin/sh -e

echo "Invoking fake hostnamectl \$*"
exit 0
EOF
chmod +x /usr/sbin/hostnamectl


cat > /usr/sbin/timedatectl <<EOF
#!/bin/sh -e

echo "Invoking fake timedatectl \$*"
exit 0
EOF
chmod +x /usr/sbin/timedatectl

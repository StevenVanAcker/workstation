#!/bin/sh
# DESCRIPTION: Audio/Video tools

#alsoftrc moving stuff:
#	https://steamcommunity.com/app/93200/discussions/0/864959809826195633/
#special sound routing
#	https://obsproject.com/forum/threads/capture-single-pulseaudio-stream.35170/



apt-get install -y 	pavucontrol \
					pasystray \
					vlc \
					kdenlive \
					obs-studio

# Build pagraphcontrol
# Hint: right click in pagraphcontrol to create a loopback, which will forward its input to its output
apt-get install -y npm
npm install -g yarn

if [ ! -d /opt/pagraphcontrol ];
then
	cd /opt
	git clone https://github.com/futpib/pagraphcontrol.git
	cd /opt/pagraphcontrol
	yarn install
	yarn build
fi

ln -sf /opt/pagraphcontrol/dist/pagraphcontrol-linux-x64/pagraphcontrol /usr/local/bin/pagraphcontrol


# Build papeaks
if [ ! -d /opt/papeaks ];
then
	cd /opt
	git clone https://github.com/futpib/papeaks.git
	cd /opt/papeaks
	cargo build --release
fi

ln -sf /opt/papeaks/target/release/papeaks /usr/local/bin/papeaks


# add virtual sink for pulseaudio
mkdir -p /home/$MAINUSER/.config/pulse
cp /etc/pulse/default.pa /home/$MAINUSER/.config/pulse/default.pa
cat >> /home/$MAINUSER/.config/pulse/default.pa <<EOF

# Adding virtual sink
load-module module-null-sink sink_name=VirtualSink
update-sink-proplist VirtualSink device.description=VirtualSink

EOF
chown -R $MAINUSER: /home/$MAINUSER/.config

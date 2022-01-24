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


# add virtual sink for pulseaudio
mkdir -p /home/$MAINUSER/.config/pulse
cp /etc/pulse/default.pa /home/$MAINUSER/.config/pulse/default.pa
cat >> /home/$MAINUSER/.config/pulse/default.pa <<EOF

# Adding virtual sink
load-module module-null-sink sink_name=VirtualSink
update-sink-proplist VirtualSink device.description=VirtualSink

EOF
chown -R $MAINUSER: /home/$MAINUSER/.config

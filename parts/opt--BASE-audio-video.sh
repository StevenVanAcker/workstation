#!/bin/sh
# DESCRIPTION: Audio/Video tools

#alsoftrc moving stuff:
#	https://steamcommunity.com/app/93200/discussions/0/864959809826195633/
#special sound routing
#	https://obsproject.com/forum/threads/capture-single-pulseaudio-stream.35170/

# Add upstream OBS Studio repo
if curl --fail-with-body -o /dev/null https://ppa.launchpadcontent.net/obsproject/obs-studio/ubuntu/dists/mantic/Release;
then
	add-apt-repository -y ppa:obsproject/obs-studio
	yes | aptdcon --hide-terminal --refresh
fi

yes | aptdcon --hide-terminal --install="pavucontrol pasystray vlc kdenlive obs-studio npm"


# Build pagraphcontrol
# Hint: right click in pagraphcontrol to create a loopback, which will forward its input to its output
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

# add virtual webcam
yes | aptdcon --hide-terminal --install="v4l-utils ffmpeg v4l2loopback-dkms v4l2loopback-utils"

cat > /etc/modprobe.d/v4l2loopback.conf <<EOF
options v4l2loopback exclusive_caps=1 video_nr=99 card_label="VirtualCam:VirtualCam"
EOF

if ! grep -q v4l2loopback /etc/modules;
then
	echo v4l2loopback >> /etc/modules
fi

modprobe -r v4l2loopback
depmod -a
modprobe v4l2loopback

cat > /usr/local/bin/remotecam.sh <<EOF
#!/bin/bash

host=\$1

if [ "\$host" = "" ];
then
	echo "Usage: \$0 [<user>@]<SSH host>"
	exit 1
fi

# v4l2loopback sometimes flakes out, so reload it by default
# Note: no options, those are in /etc/modules, with video_nr=99
# so that the virtual camera registers as /dev/video99
sudo modprobe -r v4l2loopback
sudo modprobe v4l2loopback

(
	while true;
	do
		if v4l2-ctl --all -d /dev/video99 | grep -q "loopback: ok";
		then
			ffplay /dev/video99
		fi
		sleep 1;
	done
) &

ffplaypid=\$!
function finish {
  kill \$ffplaypid
}
trap finish EXIT

ssh \$host ffmpeg -i /dev/video0 -codec copy -f matroska - | ffmpeg -i /dev/stdin -codec copy -f v4l2 /dev/video99
EOF
chmod +x /usr/local/bin/remotecam.sh


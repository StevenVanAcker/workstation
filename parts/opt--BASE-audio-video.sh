#!/bin/sh
# DESCRIPTION: Audio/Video tools

#alsoftrc moving stuff:
#	https://steamcommunity.com/app/93200/discussions/0/864959809826195633/
#special sound routing
#	https://obsproject.com/forum/threads/capture-single-pulseaudio-stream.35170/

# Add upstream OBS Studio repo
RELEASE=$(lsb_release -cs)

if curl --fail-with-body -o /dev/null https://ppa.launchpadcontent.net/obsproject/obs-studio/ubuntu/dists/$RELEASE/Release;
then
	add-apt-repository -y ppa:obsproject/obs-studio
	yes | aptdcon --hide-terminal --refresh
else
	echo "!!! obs-studio is not supported in Ubuntu $RELEASE"
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

keepgoing=\$(mktemp)
function finish {
	rm -f \$keepgoing
}
trap finish EXIT

if [ "\$host" = "" ];
then
	echo "Usage: \$0 [<user>@]<SSH host> [<num>]"
	exit 1
fi

shift
nums=\$@


if [ "\$nums" = "" ];
then
	nums=0
fi

playcam() {
	rnum=\$1
	lnum=\$2
	while [ -e \$keepgoing ];
	do
		if v4l2-ctl --all -d /dev/video9\$lnum | grep -q "loopback: ok";
		then
			ffplay /dev/video9\$lnum
		fi
		sleep 1;
	done
}

streamcam() {
	rnum=\$1
	lnum=\$2
	ssh \$host ffmpeg -i /dev/video\$rnum -codec copy -f matroska - | ffmpeg -i /dev/stdin -codec copy -f v4l2 /dev/video9\$lnum
}

# v4l2loopback sometimes flakes out, so reload it by default
sudo modprobe -r v4l2loopback
sudo modprobe v4l2loopback exclusive_caps=1 video_nr=\$(echo -n \$(seq 90 97) | tr ' ' ',') card_label="VirtualCam:VirtualCam"


localnum=0
for camnum in \$nums;
do
	echo "Starting remote cam /dev/video\$camnum on /dev/video9\$localnum"
	playcam \$camnum \$localnum &
	streamcam \$camnum \$localnum &
	localnum=\$((localnum + 1))
done

while true;
do
	echo keep it going
	sleep 1;
done
EOF
chmod +x /usr/local/bin/remotecam.sh


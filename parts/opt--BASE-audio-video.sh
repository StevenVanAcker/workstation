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
	false
fi

yes | aptdcon --hide-terminal --install="pavucontrol pasystray vlc kdenlive obs-studio npm"

# add remote webcam
yes | aptdcon --hide-terminal --install="ffmpeg"

cat > /usr/local/bin/remotecam.sh <<EOF
#!/bin/bash

host=\$1

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

streamcam() {
	rnum=\$1
	ssh \$host "ffmpeg -loglevel quiet -i /dev/video\$rnum -f mpegts -" | pv | ffplay -loglevel quiet -i /dev/stdin -fflags nobuffer
}

for camnum in \$nums;
do
	echo "Starting remote cam /dev/video\$camnum"
	streamcam \$camnum &
done

while true;
do
	sleep 1;
done

EOF
chmod +x /usr/local/bin/remotecam.sh


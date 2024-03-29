#!/bin/bash -e

shopt -s nullglob

export DEBIAN_FRONTEND=noninteractive
export MAINUSER=$(id -nu 1000)
echo "Main user: $MAINUSER"
export PROFILE=$(cat /etc/hostname 2> /dev/null|| echo default);
export INSTALL_PROFILE=$PROFILE

msgpref="Installing workstation ($PROFILE)"

localerrors=""

showmsg() {
	echo "### $msgpref $1"
	# which plymouth > /dev/null && plymouth display-message --text="$msgpref $1" || true
}

finalerror() {
	echo "ERROR: $1" 1>&2
	kill $$
	exit 1
}

localerror() {
	echo
	echo "LOCAL ERROR RUNNING $1" 1>&2
	echo
	localerrors="$localerrors $1"
}

RunPart() {
	fn=$1
	showmsg "Running $fn"
	./$fn || localerror "$fn"
	showmsg "Done running $fn"
}

GetSelection() {
	if [ -e "profiles/$PROFILE" ];
	then
		# if the profile exists, load the selection from file
		# after removing any comments
		preselection=$(cat profiles/$PROFILE | sed 's:#.*::')
	else
		if [ "$PROFILE" = "ALL" ];
		then
			preselection=$(for i in  parts/opt--*.sh; do basename $i .sh | sed 's:^opt--::'; done)
		else
			preselection=""
		fi
	fi
	echo $preselection
}

PartsFromSelection() {
	for p in $(GetSelection);
	do
		fn="parts/opt--$p.sh"
		if [ -x $fn ];
		then
			echo $fn
		else
			finalerror "Unknown optional part '$p'"
		fi
	done
}

selparts=$(PartsFromSelection)
showmsg "Selected optional packages: $selparts"

for i in parts/pre--*.sh; do RunPart $i; done
for i in $selparts; do RunPart $i; done
for i in parts/post--*.sh; do RunPart $i; done

if [ ! -z "$localerrors" ];
then
	echo "ERRORS REPORTED for $localerrors"
	exit 1
fi

showmsg "Done."

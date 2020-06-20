#!/bin/bash
# USAGE: configure.sh $ipaddr||DNSname full_path_to_pemkey
progname=${0##*/}          # Name of script
toppid=$$                  # This PID
results=/dev/null          # For traps
ruser="ubuntu"

trap "exit 1" 1 2 3 15     # SIGs we like

# Bailout subroutine won't trap most CTRL+foo
bomb()
{
    cat >&2 <<ERRORMESSAGE

ERROR: $@
*** ${progname} aborted ***
ERRORMESSAGE
    kill ${toppid}
    exit 1
}

remote=$1
keyfile=$2

if [ ! $remote ]; then
	bomb "No address found"
fi

if [ ! $keyfile ]; then
	bomb "Error, no keyfile found."
fi

# Setup python symlink so ansible will work
ssh -i $keyfile $ruser@$remote sudo \
        "ln -s /usr/bin/python3 /usr/bin/python" 

# scoop up the authkeys for the instance
ssh -i $keyfile $ruser@$remote cat \
        /home/ubuntu/.ssh/authorized_keys > .keys/$2.authorized_keys


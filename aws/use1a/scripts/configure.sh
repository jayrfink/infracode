#!/bin/bash
progname=${0##*/}          # Name of script
toppid=$$                  # This PID
results=/dev/null          # For traps
ruser="ubuntu"
IP_TYPE="public_ip"        # if private we only populate hosts

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

for i in `grep $IP_TYPE ../terra/terraform.tfstate |grep -v associate|awk '{print $2}'|sed s/\"//g|sed s/\,//`; do
	echo $i >> ../hosts
done

if [ $IP_TYPE == "private_ip" ]; then
	exit $?
fi

exit 0

keyfile=`ls ../.keys/*.pem`

for remote in `grep $IP_TYPE ../terra/terraform.tfstate |grep -v associate|awk '{print $2}'|sed s/\"//g|sed s/\,//`; do

	if [ ! $remote ]; then
		bomb "No address found"
	fi

	if [ ! $keyfile ]; then
		bomb "Error, no keyfile found in ../.keys"
	fi

	# Setup python symlink so ansible will work
	ssh -i $keyfile $ruser@$remote sudo \
         "ln -s /usr/bin/python3 /usr/bin/python" 

	# scoop up the authkeys for the instance
	ssh -i $keyfile $ruser@$remote cat \
         /home/ubuntu/.ssh/authorized_keys > ../.keys/authorized_keys
done

export ANSIBLE_INVENTORY="../hosts"
echo "Set inventory to $ANSIBLE_INVENTORY"
cd ../plays
echo "Configuring"
for play in `ls` ; do
	ansible-playbook --key-file $keyfile $play
done

echo $?

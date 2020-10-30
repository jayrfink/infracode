#!/bin/bash
# This is 1/2 a nagios check looking
# for any signs of the anchor_linux
# attack. Unfortunately it only 
# finds things *after* the attack
# It drops a stubfile into /var/tmp
# which nagios mines for alerts
# This is NOT IDEAL it could be better
ANCHOR_LOG=anchor.log
STAT=/var/tmp/hunter.stat

# clear the statfile
>$STAT

# make sure perms are good
chown nagios:nagios $STAT
chmod 0600 $STAT

if [ -f /tmp/$ANCHOR_LOG ]; then
	echo "CRITICAL: $ANCHOR_LOG found in /tmp!" > $STAT
	exit 2
fi

if [ -f /var/tmp/$ANCHOR_LOG ]; then
	echo "CRITICAL: $ANCHOR_LOG found in /var/tmp!" > $STAT
	exit 2
fi

# it is looking for:
# */1 * * * * root somefile
# it looks for */1* and root
# So if you have:
# */14 * * * * root REAL_SCRIPT
# This won't work... 
# First we get a list of crontabs then go through them
if [ -d /var/spool/cron/crontabs ]; then
	tabs=`ls /var/spool/cron/crontabs/`
	for c in $tabs; do
		grep -i "\*\/1" /var/spool/cron/crontabs/$c|grep root
		if [ $? -eq 0 ]; then
			echo "WARNING: Potential Anchor Linux Crontab found." > $STAT
			exit 1
		fi
	done
fi

# This is fuzzy which is why it is
# Anchor_Linux leaves a 15 char bin file in /tmp.
# Because I am untrusting I check /var/tmp too
# a warning only:
cd /tmp
for f in *; do 
	if [ "${#f}" == "15" ]; then
		echo "WARNING: Possible trojan payload in /tmp." > $STAT
		exit 1
	fi
done
cd /var/tmp
for f in *; do 
	if [ "${#f}" == "15" ]; then
	# DEBUG
	#	echo ${#f}
		echo "WARNING: Possible trojan payload in /var/tmp." > $STAT
		exit 1
	fi
done

echo "OKAY: No fingerprints found" > $STAT
exit 0

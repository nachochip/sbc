#!/bin/bash
#Crontab will start this script every minute....then exits.
#This script checks if another script is running.
# every minute since I have to have upstart? or init? or CRON? check this
CHECKING="02second"
RESULTE=`pgrep ${CHECKING}`
RUNPGM=~/02second.sh

if [ "${RESULTE:-null}" = null ]; then
	echo "not running, starting"
	$RUNPGM &
else
	echo "great, already running"
fi

exit 0

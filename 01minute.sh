#!/bin/bash
#Crontab will start this script every minute....then exits.
#This script checks if another script is running.
# every minute since I have to have upstart? or init? or CRON? check this

cd ~/

PROCESSA=02second.sh
RESULTA=`top -n1 -b | grep ${PROCESSA}`
PROCANDARGSA=~/02second.sh

if [ "${RESULTA:-null}" = null ]; then
	echo "not running app, starting ${PROCESSA}"
	$PROCANDARGSA &
else
	echo "great, already running ${PROCESSA}"
fi

exit 0

#!/bin/bash
#Crontab will start this script every minute.
#This script checks itself first.
#This script then checks if another script is running, every second.

PROCESS="03streaming"
PROCANDARGS=~/03streaming.sh

while :
do
RESULT=`pgrep ${PROCESS}`

if [ "${RESULT:-null}" = null ]; then
       	echo "not running, starting 03streaming.sh"
       	$PROCANDARGS &
else
       	echo "great, already running 03streaming.sh"
fi
sleep 1
done

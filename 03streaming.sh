#!/bin/bash

######     Hmmmm, why do I have this other than another layer of every-second checks......right now, let me work on the encoding script
####   maybe I will activate this later

#Crontab will start this script every minute.
#This script checks itself first.
#This script then checks if another script is running, every second.

cd ~/

PROCESS=04addthisto03.sh
PROCANDARGS=~/04addthisto03.sh

while :
do
RESULT=`top -n1 -b | grep ${PROCESS}`

if [ "${RESULT:-null}" = null ]; then
       	echo "not running, starting ${PROCESS}"
       	$PROCANDARGS &
else
       	echo "great, already running ${PROCESS}"
fi
sleep 1
done

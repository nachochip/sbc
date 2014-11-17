#!/bin/bash

######     Hmmmm, why do I have this other than another layer of every-second checks......right now, let me work on the encoding script
####   maybe I will activate this later

#Crontab will start this script every minute.
#This script checks itself first.
#This script then checks if another script is running, every second.

PROCESS="init"
PROCANDARGS=~/03streaming.sh

while :
do
RESULT=`pgrep ${PROCESS}`

if [ "${RESULT:-null}" = null ]; then
       	echo "not running, starting 03streaming.sh"
       	$PROCANDARGS &
else
       	echo "great, already running init"
fi
sleep 1
done

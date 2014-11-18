#!/bin/bash
#Crontab will start this script every minute.
#This script checks itself first.
#This script then checks if another script is running, every second.

cd ~/

PROCESSB=03streaming.sh
PROCANDARGSB=~/03streaming.sh

while :
do
RESULTB=`top -n1 -b | grep ${PROCESSB}`

if [ "${RESULTB:-null}" = null ]; then
       	echo "not running, starting ${PROCESSB}"
       	$PROCANDARGSB &
else
       	echo "great, already running ${PROCESSB}"
fi
sleep 1
done

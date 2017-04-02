#!/bin/sh
#  This script checks the wifi and reconnects to appropriate one if not.
#while true; do ./your-script & sleep 5; done

UNDESIREDSSID="Public"
TARGETSSID="Skybreak"
TARGETROUTE="10.0.0.1"

iwgetid -r | grep $UNDESIREDSSID
if [ $? -eq 0 ] ; then
	sudo ifdown --force wlan0 && sudo ifup --force wlan0
else
	iwgetid -r | grep $TARGETSSID
	if [ $? -eq 0 ] ; then
		route -n | grep $TARGETROUTE
			if [ $? -eq 0 ] ; then
				echo "should be ok"
			else
				sudo dhcpcd -n wlan0
#				dhclient wlan0
			fi
	else
		sudo ifdown --force wlan0 && sudo ifup --force wlan0
	fi
fi

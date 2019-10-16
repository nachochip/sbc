#!/bin/sh
#  This script checks the wifi and reconnects to appropriate one if not.
#while true; do ./your-script & sleep 5; done

UNDESIREDSSID="Public"
TARGETSSID="Skybreak"
TARGETROUTE="10.0.0.1"

iwgetid -r | grep $UNDESIREDSSID
if [ $? -eq 0 ] ; then
	echo "Public wifi found, rebooting wifi" | mail -s "rebooting wifi" root
	sudo ifdown --force wlan0 && sudo ifup --force wlan0
else
	iwgetid -r | grep $TARGETSSID
	if [ $? -eq 0 ] ; then
		route -n | grep $TARGETROUTE
			if [ $? -eq 0 ] ; then
				echo "should be ok"
			else
				echo "route not found, rebooting wifi" | mail -s "rebooting wifi" root
				sudo ifdown --force wlan0 && sudo ifup --force wlan0
#				sudo dhcpcd -n wlan0
#				sudo dhclient wlan0
			fi
	else
		top -bin1 > /home/pi/topoutput.txt
		echo "Skybreak not found, rebooting wifi" | mail -s "rebooting wifi" -A /home/pi/topoutput.txt root
		sudo ifdown --force wlan0 && sudo ifup --force wlan0
	fi
fi

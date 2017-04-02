#!/bin/sh
#  This script checks the wifi and reconnects to appropriate one if not.
#while true; do ./your-script & sleep 5; done

TARGETSSID="skybreak"

route | grep $TARGETSSID
if [ $? -eq 0 ] ; then
	echo "connected"
else
	sudo ifdown wlan0
	sudo ifup wlan0
fi

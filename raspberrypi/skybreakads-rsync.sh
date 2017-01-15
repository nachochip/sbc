#!/bin/sh
#  This script runs the rsync command over an over to sync up the pictures
#while true; do ./your-script & sleep 5; done

LOCALMOUNT="/home/pi/mounted-drives/covenantshare/skybreak-ads-only/"

mountpoint $LOCALMOUNT
if [ $? -eq 0 ] ; then
#if mount | grep "on ${volume} type" > /dev/null; then
#if mount | grep "on $LOCALMOUNT" > /dev/null; then
	rsync -azvh --delete-after $LOCALMOUNT /home/pi/Pictures/skybreak-ads/
else
	sudo mount -a
	mountpoint $LOCALMOUNT
	if [ $? -eq 0 ] ; then
		rsync -azvh --delete-after $LOCALMOUNT /home/pi/Pictures/skybreak-ads/
	else
		echo "not rsyncing anything, leaving as is"
		#if this doesn't work, try setting a Skybreak logo as default with
		# a 'network malfunction' in the logo
	fi
fi

#!/bin/bash
# this script allows us to encode video services

# move files to broadcast computer
#check mounts and rsync // add this mount under /etc/fstab
# //hd-recorder-v2.local/d-drive/INPUT /home/broadcast/delete-temp-mount cifs guest,uid=1000,iocharset=utf8,rw,_netdev 0 0
LOCALMOUNT="~/delete-temp-mount"
LOCALTARGET="~/delete-temp-target-local"

mountpoint $LOCALMOUNT
if [ $? -eq 0 ] ; then
#if mount | grep "on ${volume} type" > /dev/null; then
#if mount | grep "on $LOCALMOUNT" > /dev/null; then
#	rm -f .*jpg $LOCALMOUNT
	rsync -azvh --delete-after --exclude=".*" $LOCALMOUNT $LOCALTARGET
else
	sudo mount -a
	mountpoint $LOCALMOUNT
	if [ $? -eq 0 ] ; then
#		rm -f .*jpg $LOCALMOUNT
		rsync -azvh --delete-after --exclude=".*" $LOCALMOUNT $LOCALTARGET
	else
        	echo "not rsyncing anything, leaving as is"
		#if this doesn't work, try setting a Skybreak logo as default with
		# a 'network malfunction' in the logo
	fi
fi



# integrate THIS SO I can ONLY rsync files within last 24 hours
# https://ubuntuforums.org/showthread.php?t=1837771
find $LOCALMOUNT -cmin -10080 -type f -print0 | rsync -0azvh --delete-after --exclude=".*" --files-from=- $LOCALMOUNT $LOCALTARGET

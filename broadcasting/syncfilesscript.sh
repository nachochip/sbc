#!/bin/bash
# this script allows us to sync the files in preparation of encoding video services

# this script does the following:
# - moves files to broadcast computer
# - checks mounts and rsync // NOTE: add the following line to mount under /etc/fstab
# - //hd-recorder-v2.local/d-drive/INPUT /home/broadcast/delete-temp-mount cifs guest,uid=1000,iocharset=utf8,rw,_netdev 0 0
# - make sure user is correct on these next two lines
LOCALMOUNT="/home/broadcast/delete-temp-mount"
LOCALTARGET="/home/broadcast/delete-temp-target-local"

mountpoint $LOCALMOUNT
if [ $? -eq 0 ] ; then
	# find only files within last 7 days in minutes
	cd $LOCALMOUNT
	find . -cmin -10080 -type f -print0 | rsync -0azvh --delete-after --exclude=".*" --files-from=- $LOCALMOUNT $LOCALTARGET
	# this next part removes files older than 7 days
	find $LOCALTARGET -cmin +10080 -type f -exec rm {} \;
else
	sudo mount -a
	mountpoint $LOCALMOUNT
	if [ $? -eq 0 ] ; then
		# find only files within last 7 days in minutes
		cd $LOCALMOUNT
		find . -cmin -10080 -type f -print0 | rsync -0azvh --delete-after --exclude=".*" --files-from=- $LOCALMOUNT $LOCALTARGET
		find $LOCALTARGET -cmin +10080 -type f -exec rm {} \;
	else
        	echo "not rsyncing anything, leaving as is"
	fi
fi


## Next step
## working rough draft scripts are in /home/ripena/bin; make sure to use "delete-my-own" folder to test

# Encoding questions are in the next script......probably will run that manually, unless I want to have
# a person put details in a file?  which one?  hmmmm will think

## work on this part later
# setup emailing steps
# Emailing about files already saved,very tough since I have to trigger only an actual sync
# maybe detect or grep report for files above 5MB(due to audio)? For the trigger
##

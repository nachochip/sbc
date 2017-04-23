#!/bin/bash
# This script should be run on a standalone computer to restore the backup files for the RPI

# let's set the folders
echo "Where are your files located (e.g. ~/home -or- /media/ripena/databackup)"
read LOCATESPOT

# ask for partition
sudo fsarchiver probe
echo "Type the drive/partition you are going to restore to (e.g. type 'sdb' if /dev/sdb)?"
read DRIVELET

# let's set the date
ls ${LOCATESPOT}/
echo "What is the date you want to restore? (e.g. 20170421)"
read ACTIVEDATE

# 1) Restore drive MBR:
gunzip -c ${LOCATESPOT}/${ACTIVEDATE}-0-*.img.gz | sudo dd of=/dev/${DRIVELET}
sudo sync && sudo partprobe
# 2) unmount all drives for writing
#sudo umount /dev/${DRIVELET}1
#sudo umount /dev/${DRIVELET}2
#sudo umount /dev/${DRIVELET}3
# 3) restore each partition
#sudo partimage -od -f3 -z1 -b restore /dev/sd${DRIVELET}1 YYYYMMDD-boot-partition.partimg.gz
# since partimage is not working, use partclone
gunzip -c ${LOCATESPOT}/${ACTIVEDATE}-1-*.img.gz | sudo partclone.restore -d -s - -o /dev/${DRIVELET}1
sudo fsarchiver -j 4 restfs ${LOCATESPOT}/${ACTIVEDATE}-2-*.fsa id=0,dest=/dev/${DRIVELET}2
sudo fsarchiver -j 4 restfs ${LOCATESPOT}/${ACTIVEDATE}-3-*.fsa id=0,dest=/dev/${DRIVELET}3

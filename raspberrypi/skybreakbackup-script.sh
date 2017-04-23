#!/bin/bash
# this script creates backups on a weekly basis, scheduled on anacron/cron

# let's set the date
USEDATE=$(date + "%Y%m%d")
# let's set the folder for all backups
WORKINGFOLDER="/media/pi/databackup"
# command to clear previous backups that are older than 15 days (keeps 2 weeks of backup)
find ${WORKINGFOLDER}/* -mtime +15 -exec rm {} \;

# Backup via FSARCHIVER:
# 1) backup MBR/Partition
(sudo dd if=/dev/mmcblk0 bs=512 count=1 | gzip -c > ${WORKINGFOLDER}/${USEDATE}-0-MBR-and-Partition-Table.img.gz) | tee -a ${WORKINGFOLDER}/${USEDATE}-logfiles.log
# 2) backup each partition
# partimage - due to fat32 & compressed
sudo umount /dev/mmcblk0p1
#sudo partimage -od -f3 -z1 -b save /dev/mmcblk0p1 ${WORKINGFOLDER}/${USEDATE}-1-boot-partition.partimg.gz
# use partclone since partimage is being weird on the resulting restoration process
(sudo partclone.fat32 -c -d -s /dev/mmcblk0p1 | gzip -c > ${WORKINGFOLDER}/${USEDATE}1-boot-partition-partclone.img.gz) | tee -a ${WORKINGFOLDER}/${USEDATE}-logfiles.log
sudo mount -a
# all root filesystems will not let me remount as read-only, so I am adding -A to the fsarchiver command to force backup
(sudo fsarchiver -z 3 -j 4 -A savefs ${WORKINGFOLDER}/${USEDATE}-2-main-partition.fsa /dev/mmcblk0p2 --exclude='/tmp/*') | tee -a ${WORKINGFOLDER}/${USEDATE}-logfiles.log
(sudo fsarchiver -z 3 -j 4 -A savefs ${WORKINGFOLDER}/${USEDATE}-3-backup-partition.fsa /dev/mmcblk0p3 --exclude='*') | tee -a ${WORKINGFOLDER}/${USEDATE}-logfiles.log
# make sure all files are accessible via users
sudo chown pi -fR ${WORKINGFOLDER}/*
sudo chgrp pi -fR ${WORKINGFOLDER}/*

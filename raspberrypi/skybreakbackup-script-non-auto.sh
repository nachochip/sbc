#!/bin/bash
# this script creates backups on a weekly basis, scheduled on anacron/cron

# let's set the date
USEDATE=$(date +%Y%m%d)
# let's set the folder for all backups
WORKINGFOLDER="/home/pi/networkbackup/lc-rpi"
# command to clear previous backups that are older than 15 days (keeps 2 weeks of backup)
find ${WORKINGFOLDER}/* -mtime +15 -exec rm {} \;

# Backup via FSARCHIVER:
# 1) backup MBR/Partition
sudo dd if=/dev/mmcblk0 bs=512 count=1 | gzip -c > ${WORKINGFOLDER}/${USEDATE}-0-MBR-and-Partition-Table.img.gz
sudo dd if=/dev/mmcblk0p2 | gzip -c > ${WORKINGFOLDER}/${USEDATE}-2-extended-partition-table.img.gz
# 2) backup each partition
# partimage - due to fat32 & compressed
sudo umount /dev/mmcblk0p1
sudo umount /dev/mmcblk0p6
#sudo partimage -od -f3 -z1 -b save /dev/mmcblk0p1 ${WORKINGFOLDER}/${USEDATE}-1-boot-partition.partimg.gz
# use partclone since partimage is being weird on the resulting restoration process
sudo partclone.fat32 -c -d -s /dev/mmcblk0p1 | gzip -c > ${WORKINGFOLDER}/${USEDATE}-1-noobs-boot-partition-partclone.img.gz
sudo partclone.fat32 -c -d -s /dev/mmcblk0p6 | gzip -c > ${WORKINGFOLDER}/${USEDATE}-6-boot-partition-partclone.img.gz
sudo mount -a
sudo sync && sudo partprobe

# all root filesystems will not let me remount as read-only, so I am adding -A to the fsarchiver command to force backup
sudo fsarchiver -z 3 -j 4 -A savefs ${WORKINGFOLDER}/${USEDATE}-5-settings-partition.fsa /dev/mmcblk0p5
sudo fsarchiver -z 3 -j 4 -A savefs ${WORKINGFOLDER}/${USEDATE}-7-main-partition.fsa /dev/mmcblk0p7 --exclude='/home/pi/networkbackup/*'

# make sure all files are accessible via users
sudo chown pi -fR ${WORKINGFOLDER}/*
sudo chgrp pi -fR ${WORKINGFOLDER}/*

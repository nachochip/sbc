#!/bin/sh
#  This script runs the rsync command over an over to sync up the pictures
#while true; do ./your-script & sleep 5; done


while true ;

do skybreakads-rsync.sh & skybreak-wifi-persistence.sh & sleep 15 ;

done

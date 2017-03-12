#!/bin/sh
#pkill skybreakads.sh
#killall eog
#sleep 30
#sudo -u pi eog --slide-show /home/pi/skybreak-ads/ --display=':0' --fullscreen
gsettings set org.gnome.eog.fullscreen seconds 10

eog --slide-show /home/pi/Pictures/skybreak-ads/ --display=':0' --fullscreen
#eog --slide-show /home/pi/mounted-drives/covenantshare/skybreak-ads-only --display=':0' --fullscreen

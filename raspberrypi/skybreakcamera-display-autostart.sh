#!/bin/sh
# This script will start up the cameras with the proper settings.

#clear all previous
killall raspivid

# this command changes the framrate from 60 fps to 59.94 fps
tvservice -t -e "CEA 5"

# this command starts the video
raspivid -f -t 0 -awb fluorescent -ISO 100

#!/bin/sh
# This script will start up the cameras with the proper settings.

#clear all previous
killall raspivid

# this command changes the framrate from 60 fps to 59.94 fps
tvservice -t -e "CEA 5"

# this command starts the video
# -f, fullscreen
# -t 0, never timeout
# -vs, video stabilisation
# -awb, color temperature
# -ISO, ISO
# -md, mode [1=1920x1080 (max 30fps) / 6=1280x720 (max 90fps) / 5=1640x922(max 40fps)]
# -fps, see line above for max setting
# target is [ -md 1 -fps 29.97  //-or-//  -md 6 -fps 59.94 ]
# -ae, text  to display camera
# -cfx, 128:128 = black&white   //  100:150 = sepia
# -ifx, image effects (useful:  )
#myID='-ae 120,0xff,0x808000 -a $(hostname)'
#myColorEffects='-cfx 128:128'
#myImageEffects='-ifx cartoon'

#raspivid -f -t 0 -vs -awb fluorescent -ISO 100 -md 6 -fps 59.94 &

raspivid -f -t 0 -vs -awb fluorescent -ISO 100 -md 6 -fps 59.94 ${myID} ${myColorEffects} ${myImageEffects} &

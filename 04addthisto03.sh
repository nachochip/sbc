#!/bin/bash
# This script will run the encoding command inside the FFMPEG container.
# Future versions will either insert a video when no stream is detected
# or it will play a video when no stream is detected, but in this example
#  it will be breaking the stream.....and a viewer will have to refresh and re-play.

# Stream commands here
# sbc.smil contains following total bitrates kbps: 8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181

# INPUT
#Input="rtmp://10.0.0.10/livecf/hd"
Input="rtmp://23.21.227.80/livecf/hd"
#Input="rtmp://23.21.227.80/livecf/myStream3"
#Input="/www/bjput-full.mp4"
#Input="/www/bjput-song.mp4"
#Input="/www/bjput-clip.mp4"

# VIDEO CONFIGS
#################
#testingDefprocess="-vcodec copy"
testingDefprocess="-vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 60 -keyint_min 60 -sc_threshold 0 -r 29.97 -preset faster"
########### try without first and see how it multi-encodes ###############
# Currently, libx264 is best x.264 encoder
#	(I suggest converting to x.265 when more popular)
# this will force h.264 profile and levels, will not be using since I will let it auto-apply according to resultion size
# -profile:v baseline -level 3.0
# -g will set the GOP length, which marks the keyframe, each keyframe should be an i-frame, so related to FPS as well.
# @30fps, the 60 GOP size will set a keyframe every 2 seconds. @60fps, the 60 GOP size will set a keyframe every 1 second.
# -keyint_min will limit variability of the GOP, and -sc_threshold will disable scene detection = all will control GOP size.
# this will set the reference frame number, which tells the encoder the number of frames it can reference when encoding.
# I won't be using this since I am already controlling GOP.  I will let it refer to as many frames as it wants.
# -refs 1
# -preset faster adjusts the intensity of calculations
# (options = ultrafast,superfast, veryfast, faster, fast, medium, slow, slower, veryslow)
# default is medium, but I have changed to "faster" to lessen impact on CPU, some have even gone down to ultrafast
###################

# AUDIO CONFIGS
###################
#### TODO #######
# Currently, libfdk_aac is best AAC encoder
#	(there is some higher frequency limit which can be removed via a command option)
#  frequency limits from libfdk?, bits?(24bits/10bits?)
# Build out audio options as well (i.e. libfdk_aac = small NOTE: change frequency limit and test if better)
#Middleaudio="-acodec copy"
Middleaudio="-acodec libfdk_aac -ar 44.1k"
###################

# OUTPUT
# I wonder if we will need " live=1" ?  I think only for FMS servers
#Output="-f flv rtmp://10.0.0.10/livecf/sbc"
Output="-f flv rtmp://23.21.227.80/livecf/sbc"
#################
#Output="-y /www/20150303/realtime"
# ENDING (?live=1 is used for rtmp, mp4 is used when testing to a file) (((didn't really work when used with wowza)
#Testend="?live=1"
#Testend=".mp4"
#################

# COMMAND
# add -re for realtime input of a file (only for testing), but also for running a temporary video during downtime!!!

#####################
# Insert profiles and levels:  I noticed High profile was pushed through on the old wowza....need to adjust here.
# I am not sure what the new wowza is pushing through since I am having temporary rtmp copy issues. Good to adjust anyway.
# adjust sbc.smil = it only has 13, not 14 streams......here we have 14, kill bigger stream??
##################################
# loglevel (info-default, verbose, debug) -report will assume at least a verbose level
# add in -report to write a log inside the container....here I want it to write to std out, will be logged in host's own upstart log
ffmpeg -loglevel verbose \
-i ${Input} \
${testingDefprocess} -s 1920x1080 -profile:v high -level 4.0     -b:v $((4181-320))k ${Middleaudio} -b:a 320k ${Output}14${Testend} \
${testingDefprocess} -s 1280x720  -profile:v main -level 3.1     -b:v $((2584-160))k ${Middleaudio} -b:a 160k ${Output}13${Testend} \
${testingDefprocess} -s 1280x720  -profile:v main -level 3.1     -b:v $((1597-160))k ${Middleaudio} -b:a 160k ${Output}12${Testend} \
${testingDefprocess} -s 640x360   -profile:v baseline -level 3.0 -b:v $((987-160))k  ${Middleaudio} -b:a 160k ${Output}11${Testend} \
${testingDefprocess} -s 640x360   -profile:v baseline -level 3.0 -b:v $((610-160))k  ${Middleaudio} -b:a 160k ${Output}10${Testend} \
${testingDefprocess} -s 640x360   -profile:v baseline -level 3.0 -b:v $((377-160))k  ${Middleaudio} -b:a 160k ${Output}9${Testend} \
${testingDefprocess} -s 320x180   -profile:v baseline -level 1.3 -b:v $((233-80))k   ${Middleaudio} -b:a 80k  ${Output}8${Testend} \
${testingDefprocess} -s 320x180   -profile:v baseline -level 1.3 -b:v $((144-80))k   ${Middleaudio} -b:a 80k  ${Output}7${Testend} \
${testingDefprocess} -s 320x180   -profile:v baseline -level 1.3 -b:v $((89-40))k    ${Middleaudio} -b:a 40k  ${Output}6${Testend} \
${testingDefprocess} -s 320x180   -profile:v baseline -level 1.3 -b:v $((55-34))k    ${Middleaudio} -b:a 34k  ${Output}5${Testend} \
${testingDefprocess} -s 160x90    -profile:v baseline -level 1.1 -b:v $((34-21))k    ${Middleaudio} -b:a 21k  ${Output}4${Testend} \
${testingDefprocess} -s 160x90    -profile:v baseline -level 1.1 -b:v $((21-15))k    ${Middleaudio} -b:a 15k  ${Output}3${Testend} \
${testingDefprocess} -s 160x90    -profile:v baseline -level 1.1 -b:v $((13-10))k    ${Middleaudio} -b:a 10k  ${Output}2${Testend} \
${testingDefprocess} -s 160x90    -profile:v baseline -level 1.1 -b:v $((8))k        ${Middleaudio} -b:a 8k   ${Output}1${Testend} \

# for some reason this is putting more load on server than I want, will investigate later
#-f image2 -vf fps=fps=1/2 -update 1 -s 640x360 -y www/test.jpg
# try to write this to S3

# Nginx commands here, remember to open/close public port later, but do we really need this?
# I could just rely on S3/Cloudfront, to make sure no additional load occurs on this encoding server
# simply add a role to this server to allow writing to S3

# since I cannot directly write to s3, and rsyncing would be rather crood, I will choose to deliver
# via nginx proxy over to the wowza, and from wowza to cloudfront. need to setup this process - short TTL

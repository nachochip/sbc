#!/bin/bash
# This script will run the encoding command
# Future version will either insert a video when no stream is detected
# or it will play a video when no stream is detected, but in this example
#  it will be breaking the stream.....and a viewer will have to refresh and re-play.

# Stream commands here
# sbc.smil contains following total bitrates kbps: 8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181

# INPUT
#Input="rtmp://10.0.0.10/live/hd"
Input="rtmp://23.21.227.80/live/hd"
#Input="rtmp://23.21.227.80/live/myStream3"
#Input="/www/bjput-delete.mp4"
###################
#Input="/www/bjput-song.mp4"
#Input="/www/bjput-clip.mp4"
#Input="/www/sbc-60fps.mp4"
#Input="/www/new/output3.mp4"
#################

# CONFIGS
# Currently, libx264 is best x.264 encoder
#	(I suggest converting to x.265 when more popular)
# Currently, libfdk_aac is best AAC encoder
#	(there is some higher frequency limit which can be removed via a command option)
#testingDefprocess="-c:v libx264 -c:a libfdk_aac"
#testingDefprocess="-vcodec copy -acodec copy"
#################
#### TODO #######
#testingDefprocess="-vcodec copy"
testingDefprocess="-vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 60 -keyint_min 60 -sc_threshold 0 -r 29.97"
########### try without first and see how it multi-encodes ###############
# this will set h.264 profile and levels
# -profile:v baseline -level 3.0
# this will set the GOP which marks the keyframe, this should be an i-frame, so related to FPS as well.  30fps (I will keep 2$
# -g will set GOP length, -keyint_min will limit variability, and -sc_threshold will disable scene detection = all of which a$
# -g 60 -keyint_min 60 -sc_threshold 0"
# this will set the reference frame number, which tells the encoder the number of frames it can reference when encoding, I wo$
# -refs 1
###################

# CONFIGS?
###################
#### TODO #######
#  frequency limits from libfdk?, bits?(24bits/10bits?), 
# Build out audio options as well (i.e. libfdk_aac = small NOTE: change frequency limit and test if better)
#Middle="-acodec copy"
Middle="-acodec libfdk_aac -ar 44.1k"
###################

# OUTPUT
###########################################  change all CFC to SBC in smil files   ###############
# I wonder if we will need " live=1" ?  I think only for FMS servers
Output="-f flv rtmp://23.21.227.80/live/sbc"
#Output="-f flv rtmp://10.0.0.10/live/sbc"
#Output="outputtest"
#################
#Output="-y /www/realtime"
#################

# ENDING (remove this when testing to a rtmp server)
#Testend=".mp4"

# COMMAND
# add -re for realtime input of a file (only for testing), but also for running a temporary video during downtime!!!
#####  First number is video, 2nd is audio

#sudo docker run -v /home/ripena/projects/sbc/20141101-CFC-ec2-files/www:/www nachochip/ffmpeg:2.4.2 \
# for testing with a file, include a -re tag before input, to feed it in realtime
ffmpeg \
-i ${Input} \
${testingDefprocess} -s 1920x1080 -b:v $((4181-320))k ${Middle} -b:a 320k ${Output}14${Testend} \
${testingDefprocess} -s 1280x720 -b:v $((2584-160))k ${Middle} -b:a 160k ${Output}13${Testend} \
${testingDefprocess} -s 1280x720 -b:v $((1597-160))k ${Middle} -b:a 160k ${Output}12${Testend} \
${testingDefprocess} -s 640x360 -b:v $((987-160))k ${Middle} -b:a 160k ${Output}11${Testend} \
${testingDefprocess} -s 640x360 -b:v $((610-160))k ${Middle} -b:a 160k ${Output}10${Testend} \
${testingDefprocess} -s 640x360 -b:v $((377-160))k ${Middle} -b:a 160k ${Output}9${Testend} \
${testingDefprocess} -s 320x180 -b:v $((233-80))k ${Middle} -b:a 80k ${Output}8${Testend} \
${testingDefprocess} -s 320x180 -b:v $((144-80))k ${Middle} -b:a 80k ${Output}7${Testend} \
${testingDefprocess} -s 320x180 -b:v $((89-40))k ${Middle} -b:a 40k ${Output}6${Testend} \
${testingDefprocess} -s 320x180 -b:v $((55-34))k ${Middle} -b:a 34k ${Output}5${Testend} \
${testingDefprocess} -s 160x90 -b:v $((34-21))k ${Middle} -b:a 21k ${Output}4${Testend} \
${testingDefprocess} -s 160x90 -b:v $((21-15))k ${Middle} -b:a 15k ${Output}3${Testend} \
${testingDefprocess} -s 160x90 -b:v $((13-10))k ${Middle} -b:a 10k ${Output}2${Testend} \
${testingDefprocess} -s 160x90 -b:v $((8))k ${Middle} -b:a 8k ${Output}1${Testend} \

# for some reason this is putting more load on server than I want, will investigate later
#-f image2 -vf fps=fps=1/2 -update 1 -s 640x360 -y www/test.jpg


#  code for creating an image every 2 seconds
# try to write this to S3

# Nginx commands here, remember to open/close public port later, but do we really need this?
# I could just rely on S3/Cloudfront, to make sure no additional load occurs on this encoding server
# simply add a role to this server to allow writing to S3

# since I cannot directly write to s3, and rsyncing would be rather crood, I will choose to deliver
# via nginx proxy over to the wowza, and from wowza to cloudfront. need to setup this process - no cache

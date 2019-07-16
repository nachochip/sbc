#!/bin/bash
# this script is my temp script for encoding services
# hacked from my other script, so import any updates

echo "Date/Title of file to process (e.g. 20180505)"
read NAMEOFFILETOUSE

# values that should not be changing much
BASICVIDEOSETTINGS="-vcodec libx264 -pix_fmt yuv420p -aspect 16:9"
BASICAUDIOSETTINGS="-acodec libfdk_aac"
PATHSETTINGS="/home/ripena/Videos"
MESSAGEAUDIOSETPODCAST="-acodec libmp3lame -ar 48k -b:a 160k"
WORSHIPAUDIOSETFORSHARE="-acodec libmp3lame -ar 48k -b:a 320k"

MESSAGEVIDEOSETDROPBOX="-preset superfast -s 1920x1080 -profile:v main -level:v 4.2 -b:v 777k"
MESSAGEAUDIOSETDROPBOX="-ar 48k -b:a 160k"
MESSAGEVIDEOSETVIMEO="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 10000k"
MESSAGEAUDIOSETVIMEO="-ar 48k -b:a 320k"
SERVICEARCHIVEVIDEOSET="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 10000k"
SERVICEARCHIVEAUDIOSET="-ar 48k -b:a 320k"
WORSHIPVIDEOSET="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 3000k"
WORSHIPAUDIOSET="-ar 48k -b:a 320k"


ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 1 -passlogfile 1stlog -an -f mp4 -y /dev/null && \
	ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 2 -passlogfile 1stlog \
		$BASICAUDIOSETTINGS $SERVICEARCHIVEAUDIOSET $PATHSETTINGS/${NAMEOFFILETOUSE}-archive-service.mp4 && \
        rm 1stlog*

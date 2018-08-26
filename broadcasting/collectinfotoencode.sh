#!/bin/bash
# this script allows us to encode video services
# Here, I ask for the details and then take the appropriate steps

## Next step
## working rough draft scripts are in /home/ripena/bin; make sure to use "delete-my-own" folder to test
# Encoding questions


echo "Let's get some information.  I need some frames?/Times? from you."
echo "Date/Title of file to process (e.g. 20180505)"
read NAMEOFFILETOUSE
echo "Which message to use?"
echo "b, 1, or 2 (b=prep both messages, 1=use 1st message, 2=use 2nd message)"
read MESSAGETOUSE
echo "Speaker Name (Danny Green, Jared Ayres, etc.)"
read SPEAKERNAME
echo "For mp3tag data, I am using the following.  (Manually change if need be)"
EXTRAINFO="skybreakchurch.com"
CURRENTYEAR=$(date +%Y)
GENRE="talk"
echo $EXTRAINFO
echo $CURRENTYEAR
echo $GENRE

#CURRENTLY, USE Seconds for this, until I find something else
# THIS ACCEPTS H:M:S, and calculate? or just use
echo "Enter time as HH:MM:SS.sss"
echo "Time for SERVICE 1 start?"
read SERVICEONESTART
echo "Time for MESSAGE 1 start?"
read MESSAGEONESTART
echo "Time for MESSAGE 1 end?"
read MESSAGEONEEND
echo "Time for SERVICE 1 end?"
read SERVICEONEEND

# how to skip sermon/service two if blank?  not sure yet
echo "Time for SERVICE 2 start? (leave blank if n/a)"
read SERVICETWOSTART
echo "Time for MESSAGE 2 start? (leave blank if n/a)"
read MESSAGETWOSTART
echo "Time for MESSAGE 2 end? (leave blank if n/a)"
read MESSAGETWOEND
echo "Time for SERVICE 2 end? (leave blank if n/a)"
read SERVICETWOEND

# maybe here, try to detect title, NOT SURE how to detect file lock or if this part is automatic
# maybe detect size from mounted folder and compare to size on local copy to see if the same
# Thought=test this ffmpeg in linear and see cpu? maxing out....if not maxing out, consider parallel, two processes running at same time?



##  ffprobe to detect times and calculate?




############
############
# I AM RIGHT HERE, send this segment to deletemescript.sh in bin folder
############
############
# values that should not be changing much
#Every September, after apple announcement, review new settings for podcast & streaming
VIDEOSETTINGS="-vcodec libx264 -pix_fmt yuv420p -aspect 16:9"
AUDIOSETTINGS="-acodec libfdk_aac"
PATHSETTINGS="/home/ripena/Videos"
MESSAGEAUDIOSETPODCAST="-acodec libmp3lame -ar 48k -b:a 160k"
# profile main 3.1, ?deinterlace?bilinear? cubic interpolating,   720p, 29.97fps,  3-pass?
# audio maxvolume?,
MESSAGEVIDEOSETDROPBOX="-preset faster -b:v 777k"
MESSAGEAUDIOSETDROPBOX="-ar 48k -b:a 160k"
MESSAGEVIDEOSETVIMEO="-preset faster -b:v 10000k"
MESSAGEAUDIOSETVIMEO="-ar 48k -b:a 320k"
WORSHIPVIDEOSET="-preset faster -b:v 3000k"
WORSHIPAUDIOSET="-ar 48k -b:a 320k"
SERVICEARCHIVEVIDEOSET="-preset faster -b:v 10000k"
SERVICEARCHIVEAUDIOSET="-ar 48k -b:a 320k"

# put here according to priority
## MESSAGE = Video() Audio()
# ffmpeg MESSAGE 1

# I can put different outputs on one command
# Audio
# Video-small
# Video-big
# MIGHT NEED TO COMPILE FFMPEG WITH "enable libmp3lame" to get mp3 files!!!!!
# for now, I am encoding as m4a, just to finish my program first, then come back
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
	-ss $MESSAGEONESTART -to $MESSAGEONEEND \
	-vn $MESSAGEAUDIOSETPODCAST $PATHSETTINGS/$NAMEOFFILETOUSE.m4a \
	-ss $MESSAGEONESTART -to $MESSAGEONEEND \
	$VIDEOSETTINGS $MESSAGEVIDEOSETDROPBOX \
	$AUDIOSETTINGS $MESSAGEAUDIOSETDROPBOX $PATHSETTINGS/${NAMEOFFILETOUSE}-small.mp4 \
	-ss $MESSAGEONESTART -to $MESSAGEONEEND \
	$VIDEOSETTINGS $MESSAGEVIDEOSETVIMEO \
	$AUDIOSETTINGS $MESSAGEAUDIOSETVIMEO $PATHSETTINGS/${NAMEOFFILETOUSE}-large.mp4

# ffmpeg MESSAGE 2

## Worship = Video(?adjust according to 2GB) Audio(320kbps, nothing additional)
# ffmpeg Worship 1
# I still need to adjust the enter times and exit times == enter in seconds format or hh:mm:ss format

# ffmpeg Worship 2

## Service = Video() Audio()
# ffmpeg Service 1

# ffmpeg Service 2

# remember to move files to start uploading to AWS / GPhotos / archiving them




##################################
# COPY OF CURRENT LIVE STREAM FOR REFERENCE
#ffmpeg -report -rtbufsize 1000M \
#-f decklink -i 'DeckLink Mini Recorder 4K@9' \
#        -vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 59.94 -keyint_min 59.94 -sc_threshold 0 \
#        -r 29.97 -preset medium \
#        -s 1280x720 -profile:v high -level 3.1 \
#        -b:v 1555k -maxrate 1711k -bufsize 3110k \
#        -acodec libfdk_aac -ar 48k \
#        -b:a 320k \
#        -f flv rtmp://origin-3185.yourstreamlive.com:1935/live/yourstreamlive/in_3185_44qtgsmm_1
#
############
# shortened version of above
# ffmpeg -i /path/to/file.avi -vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -r 29.97 -preset medium -profile:v high -level 3.1 -b:v 1555k -acodec libfdk_aac -ar 48k -b:a 320k /path/to/output.mp4
#
##################################

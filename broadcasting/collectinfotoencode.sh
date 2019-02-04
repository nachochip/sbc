#!/bin/bash
# this script allows us to encode video services
# Here, I ask for the details and then take the appropriate steps

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
echo "Time for START of SERVICE 1?"
read SERVICEONESTART
echo "Time for START of MESSAGE 1?"
read MESSAGEONESTART
echo "Time for END of MESSAGE 1?"
read MESSAGEONEEND
echo "Time for END of SERVICE 1?"
read SERVICEONEEND

# how to skip sermon/service two if blank?  not sure yet
echo "Time for START of SERVICE 2? (leave blank if n/a)"
read SERVICETWOSTART
echo "Time for START of MESSAGE 2? (leave blank if n/a)"
read MESSAGETWOSTART
echo "Time for END of MESSAGE 2? (leave blank if n/a)"
read MESSAGETWOEND
echo "Time for END of SERVICE 2? (leave blank if n/a)"
read SERVICETWOEND

# maybe here, try to detect title, NOT SURE how to detect file lock or if this part is automatic
# maybe detect size from mounted folder and compare to size on local copy to see if the same
# Thought=test this ffmpeg in linear and see cpu? maxing out....if not maxing out, consider parallel, two processes running at same time?



##  ffprobe to detect times and calculate?


############
############
# I AM RIGHT HERE, send this segment to deletemescript.sh in bin folder
# Stuff finished:
# 	- basic template for pieces
#	- multi-pass encodes
#	- finished checking this script, as of 10/07/18
#	- x264 levels implemented
#	- x264 profiles implemented (don't use ultrasfast, faster in the superfast setting)
# Stuff to-do =
#	- re-build ffmpeg with libmp3lame enabled
# for now, I am encoding as m4a, just to finish my program first, then come back and change back to mp3 !!!!
# change the superfast (don't use ultrafast) back to a different preset speed !!!!
# mp3 tags and include pic in mp3
############
############
# values that should not be changing much
BASICVIDEOSETTINGS="-vcodec libx264 -pix_fmt yuv420p -aspect 16:9"
BASICAUDIOSETTINGS="-acodec libfdk_aac"
PATHSETTINGS="/home/ripena/Videos"
MESSAGEAUDIOSETPODCAST="-acodec libmp3lame -ar 48k -b:a 160k"
WORSHIPAUDIOSETFORSHARE="-acodec libmp3lame -ar 48k -b:a 320k"
# ?deinterlace?bilinear? cubic interpolating,   720p, 29.97fps?
# audio maxvolume?,
#Every September, after apple announcement, review new settings for podcast & streaming
MESSAGEVIDEOSETDROPBOX="-preset superfast -s 1920x1080 -profile:v main -level:v 4.2 -b:v 777k"
MESSAGEAUDIOSETDROPBOX="-ar 48k -b:a 160k"
MESSAGEVIDEOSETVIMEO="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 10000k"
MESSAGEAUDIOSETVIMEO="-ar 48k -b:a 320k"
SERVICEARCHIVEVIDEOSET="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 10000k"
SERVICEARCHIVEAUDIOSET="-ar 48k -b:a 320k"
WORSHIPVIDEOSET="-preset superfast -s 1920x1080 -profile:v high -level:v 4.2 -b:v 3000k"
WORSHIPAUDIOSET="-ar 48k -b:a 320k"


# ffmpeg MESSAGE 1
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $MESSAGEONESTART -to $MESSAGEONEEND \
		-vn $MESSAGEAUDIOSETPODCAST $PATHSETTINGS/$NAMEOFFILETOUSE.m4a &
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $MESSAGEONESTART -to $MESSAGEONEEND \
		$BASICVIDEOSETTINGS $MESSAGEVIDEOSETDROPBOX -pass 1 -passlogfile 1stlog -an -f mp4 -y /dev/null && \
	ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $MESSAGEONESTART -to $MESSAGEONEEND \
		$BASICVIDEOSETTINGS $MESSAGEVIDEOSETDROPBOX -pass 2 -passlogfile 1stlog \
		$BASICAUDIOSETTINGS $MESSAGEAUDIOSETDROPBOX $PATHSETTINGS/${NAMEOFFILETOUSE}-small.mp4 && \
	rm 1stlog* &
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $MESSAGEONESTART -to $MESSAGEONEEND \
		$BASICVIDEOSETTINGS $MESSAGEVIDEOSETVIMEO -pass 1 -passlogfile 2ndlog -an -f mp4 -y /dev/null && \
	ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $MESSAGEONESTART -to $MESSAGEONEEND \
		$BASICVIDEOSETTINGS $MESSAGEVIDEOSETVIMEO -pass 2 -passlogfile 2ndlog \
		$BASICAUDIOSETTINGS $MESSAGEAUDIOSETVIMEO $PATHSETTINGS/${NAMEOFFILETOUSE}-large.mp4 && \
	rm 2ndlog*

# ffmpeg MESSAGE 2 - NOT ENABLED YET
# how will I do program to disable / enable which message to use?

## Worship = Video(?adjust according to 2GB) Audio(320kbps, nothing additional)
## WHERE TO SYNC THE AUDIO FILES TO, gdrive?, dropbox?
# ffmpeg Worship 1 & 2
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
	-ss $SERVICEONESTART -to $MESSAGEONESTART \
	-vn $WORSHIPAUDIOSETFORSHARE $PATHSETTINGS/${NAMEOFFILETOUSE}-worship-audio-1.m4a &
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
	-ss $SERVICETWOSTART -to $MESSAGETWOSTART \
	-vn $WORSHIPAUDIOSETFORSHARE $PATHSETTINGS/${NAMEOFFILETOUSE}-worship-audio-2.m4a &
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
	-ss $SERVICEONESTART -to $MESSAGEONESTART \
	$BASICVIDEOSETTINGS $WORSHIPVIDEOSET \
	$BASICAUDIOSETTINGS $WORSHIPAUDIOSET $PATHSETTINGS/${NAMEOFFILETOUSE}-worship-1.mp4 \
	-ss $SERVICETWOSTART -to $MESSAGETWOSTART \
	$BASICVIDEOSETTINGS $WORSHIPVIDEOSET \
	$BASICAUDIOSETTINGS $WORSHIPAUDIOSET $PATHSETTINGS/${NAMEOFFILETOUSE}-worship-2.mp4

## ARCHIVE Service - start doing separate archive files  (CHECK TIMES especially after the ends of each section, is it correct?)
# ffmpeg Service 1 & 2
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $SERVICEONESTART -to $SERVICEONEEND \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 1 -passlogfile 1stlog -an -f mp4 -y /dev/null && \
	ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $SERVICEONESTART -to $SERVICEONEEND \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 2 -passlogfile 1stlog \
		$BASICAUDIOSETTINGS $SERVICEARCHIVEAUDIOSET $PATHSETTINGS/${NAMEOFFILETOUSE}-archive-service-1.mp4 && \
        rm 1stlog* &
ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $SERVICETWOSTART -to $SERVICETWOEND \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 1 -passlogfile 2ndlog -an -f mp4 -y /dev/null && \
	ffmpeg -i $PATHSETTINGS/$NAMEOFFILETOUSE.mkv \
		-ss $SERVICETWOSTART -to $SERVICETWOEND \
		$BASICVIDEOSETTINGS $SERVICEARCHIVEVIDEOSET -pass 2 -passlogfile 2ndlog \
		$BASICAUDIOSETTINGS $SERVICEARCHIVEAUDIOSET $PATHSETTINGS/${NAMEOFFILETOUSE}-archive-service-2.mp4 && \
        rm 2ndlog*




# mp3 tag and include pic in mp3

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

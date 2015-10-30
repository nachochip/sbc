#!/bin/bash
# modified command to send to yourstreamlive

ffmpeg \
	-i rtmp://23.21.227.80/livecf/hd \
		-vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 150 -keyint_min 150 -sc_threshold 0 -r 29.97 -preset faster \
			-s 1280x720 -profile:v main -level 3.1 \
			-b:v 1500k -acodec libfdk_aac -ar 44.1k \
			-b:a 320k \
			-f flv rtmp://origin-3185.yourstreamlive.com:1935/live/yourstreamlive/in_3185_44qtgsmm_1 \
		-vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 150 -keyint_min 150 -sc_threshold 0 -r 29.97 -preset faster \
			-s 640x360 -profile:v baseline -level 3.0 \
			-b:v 700k -acodec libfdk_aac -ar 44.1k \
			-b:a 256k \
			-f flv rtmp://origin-3185.yourstreamlive.com:1935/live/yourstreamlive/in_3185_44qtgsmm_2 \
		-vcodec libx264 -pix_fmt yuv420p -aspect 16:9 -g 150 -keyint_min 150 -sc_threshold 0 -r 29.97 -preset faster \
			-s 384x216 -profile:v baseline -level 1.3 \
			-b:v 350k -acodec libfdk_aac -ar 44.1k \
			-b:a 128k \
			-f flv rtmp://origin-3185.yourstreamlive.com:1935/live/yourstreamlive/in_3185_44qtgsmm_3

# Building FFMPEG with SBC scripts

# add the stable tag, once I implement stable tag....latest=latest && stable=to use
FROM nachochip/ffmpeg:2.4.2

MAINTAINER 	Nachochip 	<blockchaincolony@gmail.com>

ADD 	04addthisto03.sh 	/usr/local/bin/

#CMD           	["04addthisto03.sh"]
#ENTRYPOINT 	["bash"]

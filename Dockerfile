# Building LOCAL Docker Image and integrating SBC scripts

FROM 		nachochip/ffmpeg:stable

MAINTAINER 	Nachochip 	<blockchaincolony@gmail.com>

ADD		0*		/usr/local/bin/

CMD           	["04addthisto03.sh"]
ENTRYPOINT 	["bash"]

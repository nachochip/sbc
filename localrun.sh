#!/bin/bash

#run a Docker image with local volume


sudo docker run -v /home/ripena/projects/sbc/20141101-CFC-ec2-files/www:/www -it --entrypoint="bash" rplocalbuild/test:0.1

#nachochip/ffmpeg:2.4.2

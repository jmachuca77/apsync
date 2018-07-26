#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

./4_setup_log_rotation # instant
time ./6_setup_video.sh # 1m  This is optional
time ./8_setup_cmavnode.sh # ~4m
time ./setup_mavlink-router # ~2m Remember to change the mavlink_router.conf file to the right serial port
time ./7_dflogger.sh # ~210s
./5_setup_mavproxy.sh # instant
time ./setup-video-streaming # 11s  This is optional

time apt-get install -y libxml2-dev libxslt1.1 libxslt1-dev
time pip install future lxml # 4m
time ./install_pymavlink # new version required for apweb #1m
time ./install_apweb # 2m

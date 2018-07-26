#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env


ssh apsync@apsync
pushd GitHub/companion/Nvidia_JTX1/Ubuntu
time sudo -E ./2_install_packages.sh # 20m
time sudo -E ./install_niceties || echo "Failed" # 20s
echo "options bcmdhd op_mode=2" | tee -a /etc/modprobe.d/bcmdhd.conf
echo 2 >/sys/module/bcmdhd/parameters/op_mode
time sudo -E ./3_wifi_access_point.sh # 20s

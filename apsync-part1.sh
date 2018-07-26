#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

#. config.env

#pushd /home/apsync

#Update and upgrade all packages to the latest versions
apt-get update
apt-get upgrade -y

apt-get install nano
#    create an apsync user:
sudo useradd -s /bin/bash -m -U -G sudo,netdev,users,dialout,video apsync

# move all of the Jetson stuff to be under APSync:
JETSON_STUFF_USER=ubuntu
if [ -d "/home/nvidia" ]; then
    JETSON_STUFF_USER=nvidia
fi

sudo rsync -aPH --delete /home/$JETSON_STUFF_USER/ /home/apsync
sudo chown -R apsync.apsync /home/apsync
pushd /home/$JETSON_STUFF_USER
  sudo rm -rf cudnn nv-gie-repo-ubuntu1604-ga-cuda8.0-trt2.1-20170614_1-1_arm64.deb cuda-l4t /home/nvidia/OpenCV4Tegra
popd

echo >&2 "Enter password for user apsync"
#sudo passwd apsync # apsync
echo "apsync:apsync" | chpasswd

echo >&2 "Finished part 1 of APSync install, please logout and then log back in using apsync user"

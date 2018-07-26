#!/bin/bash

if [ $(id -u) -ne 0 ]; then
   echo >&2 "Must be run as root"
   exit 1
fi

set -e
set -x

. config.env

pushd /home/$NORMAL_USER

sudo -u $NORMAL_USER -H bash <<'EOF'
set -e
set -x

#To do! find a way to only create dir if its not there and remove only the companion repo!
rm -rf GitHub
mkdir GitHub
pushd GitHub
git clone https://github.com/peterbarker/companion.git
pushd companion/
git checkout next-rpi

EOF

pushd GitHub/companion/Nvidia_JTX1/Ubuntu

./set-hostname   # reset the machine's hostname
apt-get autoremove -y # avoid repeated no-longer-required annoyance
#./change-autologin-user.sh
./remove-unattended-upgrades #
./ensure_rc_local.sh
./disable_console.sh

echo >&2 "Rebooting to Finish changes"
reboot # ensure hostname correct / console disabling OK / autologin working

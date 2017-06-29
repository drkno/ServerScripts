#!/bin/sh

output=$(df -H | grep -vE "^Filesystem|udev|tmpfs|/boot|/mnt" | awk '{print $5 " " $6}')
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
if [ $usep -ge 90 ] ; then
	systemctl stop transmission-daemon.service
fi

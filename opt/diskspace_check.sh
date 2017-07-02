#!/bin/sh

[ -n "$bypassdiskspacecheck" ] && exit

output=$(df -H | grep -vE "^Filesystem|udev|tmpfs|/boot|/mnt" | awk '{print $5 " " $6}')
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
if [ $usep -ge 98 ] ; then
	echo "Filesystem is too full. Killing transmission..."
	systemctl stop transmission-daemon.service
elif ! systemctl is-active transmission-daemon.service >/dev/null 2>&1; then
	echo "Filesystem has freed up space. Resuming transmission..."
	systemctl start transmission-daemon.service
else
	echo "Happy with the status quo, leaving transmission $(systemctl is-active transmission-daemon.service)."
fi

#!/bin/bash
function getStatus() {
	local status=$(systemctl is-active "$1" >/dev/null 2>&1; echo $?)
	if [ "$status" != "0" ]; then
		printf "[\033[0;31;5mDOWN\033[0m]"
	else
		printf "[\033[1;32m OK \033[0m]"
	fi
}
function printStatus() {
	local ipAddress=$(ip -o -4 addr list eth0 | awk '{print $4;exit}' | cut -d/ -f1)
	printf " * %s %-18s http://$ipAddress:%s\n" "$(getStatus $2)" "$1" "$3"
}

printf "\033[44;1m Server Status                       \033[94m Knox Status Tool v 1.0 \033[0m\n"

printStatus Plex: plexmediaserver 80/32400
printStatus Sonarr: sonarr 8989
printStatus Radarr: radarr 7878
printStatus Jackett: jackett 9117
printStatus Ombi: ombi 3579
printStatus Transmission: transmission-daemon 9091
printStatus MongoDB: mongodb 27017

printf " * $(getStatus plexdrive) Plex Drive    * $(getStatus rclone-download) Rclone    * $(getStatus mnt-media.automount) Overlay\n"

stamp="/var/lib/update-notifier/updates-available"
usage="$(df -h | grep "/dev/vda1 " | tr -s ' ' | cut -d ' ' -f5,3,2 | awk ' { print "Disk Usage: " $3 " (" $2 "/" $1 ")" }')"
printf "\033[100m                                                             \r %s\033[0m\r" "$usage"
if [ -r "$stamp" ]; then
        output=$(cat $stamp | tr '\n' ' ' | cut -d ' ' -f2,7)
        packages=$(echo $output | cut -d ' ' -f1)
        security=$(echo $output | cut -d ' ' -f2)

        if [ "$packages" != "0" ]; then
                printf "\033[91;100;1m %s\033[0;100;37m package" "$packages"
        fi
        if [ "$packages" != "0" ] && [ "$security" != "0" ]; then
                printf " and"
        fi
        if [ "$security" != "0" ]; then
                printf "\033[91;5m %s\033[0;100;37m security" "$security"
        fi
        if [ "$packages" != "0" ] || [ "$security" != "0" ]; then
                plural=$( [ "$(($package+$security))" != "1" ] && echo "s are" || echo " is")
                printf " update$plural avalible for install. \033[0m"
        fi
fi
printf "\n"

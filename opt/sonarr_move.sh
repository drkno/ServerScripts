#!/bin/bash

[ -z "$sonarr_episodefile_path" ] && echo "Need to set sonarr_episodefile_path" && exit 1
[ -z "$sonarr_eventtype" ] && echo "Need to set sonarr_eventtype" && exit 1

if [[ $sonarr_episodefile_path/ = /mnt/media/* ]] ||
    [[ $sonarr_episodefile_path/ = /mnt/upload/* ]] ||
    [[ $sonarr_episodefile_path/ = /var/lib/transmission-daemon/downloads/sonarr/* ]]; then
    echo "Safe to move file."
else
    echo "Unsafe move! Aborting..." && exit 1
fi

subdir_path=${sonarr_episodefile_path#/mnt/media/}
echo rclone move \"$sonarr_episodefile_path\" \"remote-crypt:$subdir_path\" >> ~/test.txt
rclone move "$sonarr_episodefile_path" "remote-crypt:$subdir_path"

folder=$(basename $sonarr_episodefile_path)
if [ -z "$(ls -A $folder)" ]; then
	rm -rf $folder || true
fi

/opt/download_management.sh transmission:3T1Pe0Me0C21r91V &

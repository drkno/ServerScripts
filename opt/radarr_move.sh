#!/bin/bash

[ -z "$radarr_moviefile_path" ] && echo "Need to set radarr_moviefile_path" && exit 1;
[ -z "$radarr_eventtype" ] && echo "Need to set radarr_eventtype" && exit 1;

if [[ $radarr_moviefile_path/ = /mnt/media/* ]] ||
    [[ $radarr_moviefile_path/ = /mnt/upload/* ]] ||
    [[ $radarr_moviefile_path/ = /var/lib/transmission-daemon/downloads/radarr/* ]]; then
    echo "Safe to move file."
else
    echo "Unsafe move! Aborting..." && exit 1
fi

subdir_path=${radarr_moviefile_path#/mnt/media/}
echo rclone move \"$radarr_moviefile_path\" \"remote-crypt:$subdir_path\" >> ~/test.txt
rclone move "$radarr_moviefile_path" "remote-crypt:$subdir_path"

folder=$(dirname $radarr_moviefile_path)
rm -rf $folder || true

/opt/download_management.sh transmission:3T1Pe0Me0C21r91V &

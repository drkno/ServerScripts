#!/bin/bash

[ -z "$sonarr_episodefile_path" ] && echo "Need to set sonarr_episodefile_path" && exit 1;
[ -z "$sonarr_eventtype" ] && echo "Need to set sonarr_eventtype" && exit 1;

subdir_path=${sonarr_episodefile_path#/mnt/media/}
echo rclone move \"$sonarr_episodefile_path\" \"remote-crypt:$subdir_path\" >> ~/test.txt
rclone move "$sonarr_episodefile_path" "remote-crypt:$subdir_path"


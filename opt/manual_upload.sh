#!/bin/bash

fullPath=$(realpath $1)
fileName=$(basename "$fullPath")
extension="${fileName##*.}"

if [[ $fullPath == *"/radarr/"* ]]; then
    moveTo="remote-crypt:Movies/$2 ($3)/$2 ($3).$extension"
else
    pSeason=$(printf "%02d\n" $3)
    pEpisode=$(printf "%02d\n" $4)
    moveTo="remote-crypt:TV Shows/$2/Season $3/$2 - [$(echo $pSeason)x$(echo $pEpisode)].$extension"
fi

rclone move "$fullPath" "$moveTo"

folder=$(dirname $fullPath)
echo $folder
fileCount=$(ls --ignore "*.txt" --ignore "*.srt" --ignore "*.nfo" -1 --file-type "$folder" | grep -v '/$' | wc -l)
if [ "$fileCount" -ne "0" ]; then
    exit;
fi
rm -rf "$folder" || true


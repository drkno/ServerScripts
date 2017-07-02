#!/bin/bash

RPC_CLIENT=transmission-remote
RPC_AUTH=$1
rpc="$RPC_CLIENT -n $RPC_AUTH"

[ -z "$1" ] && echo "Auth must be provided." && exit

function get_downloading_time() {
	echo $($rpc -t $1 -i | grep "Downloading Time" | cut -d '(' -f2 | cut -d ' ' -f1)
}

function delete_torrent() {
	echo "Deleting torrent id:$1"
	echo $($rpc -t $1 -rad )
}

function start_torrent() {
	echo "Starting torrent id:$1"
	echo $($rpc -t $1 -s )
}

function get_all_ids_and_status() {
	local torrents=$($rpc -l | tr -s ' ' | grep -e "^\s*[0-9]" | cut -d ' ' -f2,9)
	for i in "${!torrents[@]}"; do
		torrent=${torrents[$i]}
		if [[ $torrent == *"*"* ]]; then
			torrent[$i]=$(echo $torrent | tr -d "*" | awk ' { print $1 " Error" }')
		fi
		echo $torrent
	done
}

function remove_by_status() {
        local torrents=$(get_all_ids_and_status | grep $1 | cut -d ' ' -f1)
        for id in $torrents; do
                delete_torrent $id
        done
}

function remove_stalled_by_age() {
	local torrents=$(get_all_ids_and_status | grep Idle | cut -d ' ' -f1)
	for id in $torrents; do
		local age=$(get_downloading_time $id)
		if (( age > $1 )); then
			delete_torrent $id
		fi
	done
}

function resume_all() {
	local torrents=$(get_all_ids_and_status | cut -d ' ' -f1)
	for id in $torrents; do
		start_torrent $id
	done
}

remove_stalled_by_age 3600
remove_by_status Error
resume_all

#!/bin/bash

#set -x

base=~/.mail
cd $base

removeUID() {
	filename=$@
	[[ -z "$filename" ]] && return
	newname=$(echo "$filename" | sed 's/,U=[0-9]\+:[0-9]*//')
	[[ -z "$newname" ]] && return
	echo $filename $newname
	[[ -f "$filename" &&  ! ( -e "$newname" ) ]] || return
	echo "Renaming file"
	mv $filename $newname
}

find -name 'cur' -type d | sed 's|/cur||' | \
while read folder; do
	echo "Folder: $folder"
	cd "${folder}"

	[[ -f ".uidvalidity" ]] || continue
	maxuid=$(cat .uidvalidity | tail -1)
	echo "Max UID: $maxuid"
	cd cur
	ls -1 | sed 's/.*U=\(.*\):.*/\1/g' | grep '^[0-9]*$' | sort -nr  | \
	while read uid; do
		if [[ $uid -le $maxuid ]]; then
			break
		fi
		echo $uid

		filename=$(ls *U=${uid}:*)
		removeUID $filename
	done

	dups=$(ls -lR | grep -o 'U=.*:' | sort | uniq -d | cut -d= -f2 | cut -d: -f1)
	for uid in $dups; do
		filenames=$(ls *U=${uid}:*)
		for filename in $filenames; do
			removeUID $filename
		done
	done

	cd $base
done

#!/usr/bin/env bash

if [[ "$1" == "--repo2system" ]]; then
	mode="repo2system"
elif [[ "$1" == "--system2repo" ]]; then
	mode="system2repo"
else
	mode="none"
fi

cd "$(dirname "$0")" || exit
base_dir="$(pwd)"

for project in * privateconf/*; do
	if [[ ! -d $project ]]; then
		continue
	fi
	if [[ "$project" == "privateconf" ]]; then
		continue
	fi
	if [[ "$project" == "udev" ]]; then
		echo "Skipping udev – please install manually"
		continue
	fi
	cd "$project" || exit
	# shellcheck disable=SC2044
	for file in $(find . -type f); do
		file=${file#./}
		full_file="$project/$file"
		# 0. File not installed on system
		if [[ ! -f "$HOME/$file" ]]; then
			echo "Missing file: $full_file"
			continue
			if [[ "$mode" == "repo2system" ]]; then
				echo "Updating system"
				ln -f "$file" "$HOME/$file"
			fi
		fi
		inode_repo=$(stat -c %i "$file")
		inode_local=$(stat -c %i "$HOME/$file")
		# 1. File is hardlinked
		if [[ $inode_local -eq $inode_repo ]]; then
			#echo "$full_file is hardlinked"
			continue;
		# 2. Files are identical
		elif cmp --silent "$file" "$HOME/$file"; then
			echo "Identical file $full_file – making it a hardlink"
			ln -f "$file" "$HOME/$file"
			continue
		# 3. Files are different & worktree clean
		elif [[ $(git status --porcelain "$file") == "" ]]; then
			if [[ "$mode" == "system2repo" ]]; then
				echo "Different file $full_file – update repo"
				ln -f "$HOME/$file" "$file"
			elif [[ "$mode" == "repo2system" ]]; then
				echo "Different file $full_file – update system"
				ln -f "$file" "$HOME/$file"
			else
				echo "Different file $full_file"
			fi
		# 4. Conflict
		else
			echo "Conflict $full_file $HOME/$file"
		fi
	done
	cd "$base_dir" || exit
done

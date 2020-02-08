#!/bin/bash

# Find the path to the root directory of this repo
repoRoot=$(git rev-parse --show-toplevel)
#echo "Repo root is $repoRoot"

checkout_latest_merge() {
	latestMerge=$(git log --oneline | grep -i "merge" | head -1 | cut -d " " -f1 )
	git checkout $latestMerge
	echo "Checked out commit $latestMerge"
}

fixme_log() {
	if [ -f "fixme.log" ] ; then
		rm "fixme.log"
	fi
	touch "fixme.log"
	fileList=$(find "$repoRoot" -type d -name '.git' -prune -o -type f -print) # from https://unix.stackexchange.com/a/350090
	IFS=$'\n' # Filepaths might have spaces in them, which breaks the for loop
	for file in $fileList ; do
		lastLine=$(tail -n 1 "$file")
		#echo $lastLine
		#echo $file
		if [ "$lastLine" == '#FIXME' ] ; then
			#echo "I am doing something"
			echo "$file" >> "./fixme.log"
		fi
		#echo "Done with this file"
	done
	unset IFS
	echo "Generated \"CS1XA3/Project01/fixme.log\"."
}

echo "Enter name of feature to run:"
read featName
echo "Running $featName..."
$featName


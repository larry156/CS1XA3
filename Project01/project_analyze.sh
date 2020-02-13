#!/bin/bash

# Find the path to the root directory of this repo
repoRoot=$(git rev-parse --show-toplevel)
#echo "Repo root is $repoRoot"

# Find the latest commit with the word "merge" in its commit message and check it out
checkout_latest_merge() {
	latestMerge=$(git log --oneline | grep -i "merge" | head -1 | cut -d " " -f1 )
	git checkout $latestMerge
	echo "Checked out commit $latestMerge"
}

# Look for files that contain the string "#FIXME" in the last line, and output their names to a log file in /Project01/
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
		if [[ "$lastLine" == *'#FIXME'* ]] ; then
			#echo "I am doing something"
			echo "$file" >> "./fixme.log"
		fi
		#echo "Done with this file"
	done
	unset IFS
	echo "Generated \"CS1XA3/Project01/fixme.log\"."
}

# Prompt the user for a file extension, and output the number of files in the repo with that extension
file_type_count() {
	echo "Enter file extension to search for (e.g. 'txt', 'py'): "
	read fileExt
	if [ -z "$fileExt" ] ; then
		echo "No file extension entered, counting all files..."
		count=$(find "$repoRoot" -type f | wc -l)
		echo "There are $count files in the repo."
	else
		echo "Counting files..."
		count=$(find "$repoRoot" -type f -name "*.$fileExt" | wc -l)
		echo "There are $count files with the '.$fileExt' extension in the repo."
	fi
}

echo "Enter name of feature to run:"
read featName
echo "Running $featName..."
$featName


#!/bin/bash

# Find the path to the root directory of this repo
repoRoot=$(git rev-parse --show-toplevel)
#echo "Repo root is $repoRoot"
# Navigate to the Project01 directory
cd "$repoRoot/Project01"

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
	fileList=$(find "$repoRoot" -type d -name '.git' -prune -o -type f -print) # Ignore the .git directory
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


switch_to_executable() {
	# Prompt the user on whether they want to change or restore permissions
	echo "Would you like to Change or Restore permissions?"
	userChoice=""
	while [ "${userChoice,,}" != "change" ] && [ "${userChoice,,}" != "restore" ] ; do # From https://stackoverflow.com/a/27679748
		echo "Enter your choice: "
		read userChoice
		if [ "${userChoice,,}" != "change" ] && [ "${userChoice,,}" != "restore" ] ; then
			echo "Invalid input."
		fi
	done
	# User wants to change permissions
	if [[ "${userChoice,,}" == "change" ]] ; then
		# Create log, overwriting if necessary
		if [ -f "permissions.log" ] ; then
			rm "permissions.log"
		fi
		touch "permissions.log"
		# Find .sh files
		scriptList=$(find "$repoRoot" -type f -name "project_analyze.sh" -prune -o -type f -name "*.sh" -print) # Exclude project_analyze.sh from being modified
		# Save original permissions and change to executable
		IFS=$'\n'
		for file in $scriptList ; do
			#echo "$file"
			perms=$(ls -l "$file" | cut -d " " -f1 )
			permsNum=$(stat -c '%a' "$file")
			echo "$permsNum \"$file\"" >> "permissions.log"
			for (( i=2; i < ${#perms}; i+=3 )) ; do
				curChar=${perms:$i:1}
				#echo $curChar
				# Add x permissions
				if [ "$curChar" == "w" ] ; then 
					if [ $i -eq 2 ] ; then
						chmod u+x "$file"
					elif [ $i -eq 5 ] ; then
						chmod g+x "$file"
					else
						chmod o+x "$file"
					fi
				# Remove x permissions
				else
					if [ $i -eq 2 ] ; then
						chmod u-x "$file"
					elif [ $i -eq 5 ] ; then
						chmod g-x "$file"
					else
						chmod o-x "$file"
					fi
				fi
			done
		done
		unset IFS
		echo "Changed permissions."
	elif [ "${userChoice,,}" == "restore" ] ; then
		# Do a chmod on each line of permissions.log
		permList=$(cat "permissions.log")
		IFS=$'\n'
		for file in $permList ; do
			#echo "$file"
			perm=$(echo "$file" | cut -d " " -f1 )
			permsPath=$(echo "$file" | cut -d " " -f2 )
			permsPath=$(echo "${permsPath//\"}")
			#echo $perm "$permsPath"
			chmod $perm "$permsPath"
		done
		unset IFS
		echo "Restored permissions."
	fi
}

echo "Enter name of feature to run:"
read featName
echo "Running $featName..."
$featName


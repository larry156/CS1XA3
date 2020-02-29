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

# Give or take away execute permissions for shell scripts.
switch_to_executable() {
	# Prompt the user on whether they want to change or restore permissions
	echo "Would you like to Change or Restore permissions?"
	userChoice=""
	while [ "${userChoice,,}" != "change" ] && [ "${userChoice,,}" != "restore" ] ; do # Case insensitive
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
			echo "$permsNum;\"$file\"" >> "permissions.log"
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
		# Check if permissions.log exists
		if [ ! -f "./permissions.log" ] ; then
			echo "Error: permissions.log not found" 1>&2
			exit 1
		fi
		# Do a chmod on each line of permissions.log
		permList=$(cat "permissions.log")
		IFS=$'\n'
		for file in $permList ; do
			#echo "$file"
			perm=$(echo "$file" | cut -d ";" -f1 )
			permsPath=$(echo "$file" | cut -d ";" -f2 )
			permsPath=$(echo "${permsPath//\"}") # Remove quotation marks from path
			#echo $perm "$permsPath"
			chmod $perm "$permsPath"
		done
		unset IFS
		echo "Restored permissions."
	fi
}

# Backup or restore temp files
backup_restore() {
	# Prompt the user on whether they want to backup & delete, or restore files
	echo "Would you like to Backup or Restore temporary files?"
	userChoice=""
	while [ "${userChoice,,}" != "backup" ] && [ "${userChoice,,}" != "restore" ] ; do 
		echo "Enter your choice: "
		read userChoice
		if [ "${userChoice,,}" != "backup" ] && [ "${userChoice,,}" != "restore" ] ; then
			echo "Invalid input."
		fi
	done
	
	# User wants to backup files
	if [ "${userChoice,,}" == "backup" ] ; then
		# Empty and create the backup folder and log file
		if [ -d "backup" ] ; then 
			rm -r "backup"
		fi
		mkdir "backup"
		touch "backup/restore.log"

		# Find .tmp files and move them to the backup folder
		tempFilesList=$(find "$repoRoot" -type f -name "*.tmp")
		count=1
		IFS=$'\n'
		for file in $tempFilesList ; do
			#echo "$file"
			echo "$file" >> "backup/restore.log"
			# Files will be named as numbers to account for the possibility of files with the same name in different locations.
			cp "$file" "./backup/$count.tmp"
			rm "$file"
			count=$(( $count + 1 ))
		done
		unset IFS
		numFiles=$(cat "./backup/restore.log" | wc -l)
		echo "Backed up $numFiles files."

	# User wants to restore files
	elif [ "${userChoice,,}" = "restore" ] ; then 
		if [ ! -f "./backup/restore.log" ] ; then
			echo "Error: restore.log not found" 1>&2
			exit 1
		fi
		origPathList=$(cat "./backup/restore.log")
		tempFilesList=$(find "./backup" -type f -name "*.tmp")
		count=1
		IFS=$'\n'
		for file in $tempFilesList ; do
			#echo "$file"
			origPath=$(echo "$origPathList" | cut -d $'\n' -f "$count")
			count=$(( $count + 1 ))
			mv "$file" "$origPath"
			#echo "$origPath"
		done
		unset IFS
		numFiles=$(cat "./backup/restore.log" | wc -l)
		echo "Restored $numFiles files to their original location."
	fi
}

# Create an HTML file from a template
html_template() {
	# Make sure template.html exists
	if [ ! -f "./template.html" ] ; then
		echo "Error: template.html not found. Please create it." 1>&2
		exit 1
	fi

	# Read in variables
	echo "Enter name of new file:"
	read fileName
	if [ -z "$fileName" ] ; then # If the user doesn't enter a name then just call it "index".
		fileName="index"
	fi
	# Replace all "/" and "\" characters with spaces in case the user actively tries to break the program that way
	fileName=${fileName//\//\ }
	fileName=${fileName//\\/\ }
	echo "Enter path to destination directory:"
	read destPath
	# If the user doesn't enter a path or the path doesn't exist, then assume that they want it in the Project01 folder.
	if [ "$destPath" == "" ] || [ ! -d "$destPath" ] ; then 
		if [ ! -d "$destPath" ] && [ "$destPath" != "" ] ; then
			echo "Warning: \"$destPath\" does not exist. Your file will be located in the Project01 folder."
		fi
		destPath="."
		# echo "$destPath"
	fi

	# echo "$destPath"
	fullPath="$destPath/$fileName.html"
	tempContents=$(cat "./template.html")
	# Capitalize the first letter in each word of the filename
	nameTitleCase="☺"
	for word in $fileName ; do
		if [ "$nameTitleCase" == "☺" ] ; then
			nameTitleCase="${word^}"
		else
			nameTitleCase="$nameTitleCase ${word^}"
		fi
	done
	tempContents="${tempContents//\%NAME\%/$nameTitleCase}" # Replace %NAME% with the file name
	if [ -f "$fullPath" ] ; then
		echo "Warning: \"$fullPath\" already exists and will be overwritten."
	fi
	echo "$tempContents" > "$fullPath"
	echo "Created \"$fullPath\"."
}

# Censor various phrases in a file.
censor_file() {
	# Check if forbidden-text.txt exists
	if [ ! -f "forbidden-text.txt" ] ; then
		echo "Error: \"forbidden-text.txt\" does not exist. Please create the file and place it in the Project01 folder." 1>&2
		exit 1
	fi
	wordList=$(cat "forbidden-text.txt")

	echo "Enter path to text file: "
	read censorPath
	if [ -f "censor-exclude.txt" ] ; then
		toExclude=$(cat "censor-exclude.txt")
		IFS=$'\n'
		for file in $toExclude ; do
			if [ "${file,,}" == "${censorPath,,}" ] ; then
				echo "Error: The file you entered is in the exclusion list." 1>&2
				echo "If you wish to censor this file, remove it from Project01/censor-exclude.txt"
				exit 1
			fi
		done
		unset IFS
	fi
	# Don't try to censor this file.
	if [[ "${censorPath,,}" == *"project_analyze.sh" ]] ; then
		echo "Error: You cannot censor that file." 1>&2
		exit 1
	fi
	if [ ! -f "$censorPath" ] ; then
		echo "Error: File does not exist." 1>&2
		exit 1
	fi
	echo "Enter censor text (Leave blank for \"[REDACTED]\"): "
	read censorString
	if [ -z "$censorString" ] ; then
		censorString="[REDACTED]"
	else
		censorString="[$censorString]"
	fi
	fileContents=$(cat $censorPath)
	fileContents="${fileContents,,}"
	echo "Forbidden words will be replaced with $censorString."

	# Loop through each forbidden phrase and replace it with censorString.
	IFS=$'\n'
	for word in $wordList ; do
		word=$(echo "$word" | xargs) # Piping echo into xargs removes leading and trailing whitespace.
		word="${word,,}"
		#echo "$word"
		#echo '${fileContents//'"$word"'/'"$censorString"'}'
		fileContents="${fileContents//$word/$censorString}"
		#echo "$fileContents"
	done
	unset IFS
	fileContents="${fileContents^^}"
	echo "$fileContents" > "$censorPath"
	echo "Removed subversive elements from \"$censorPath\"."
}

echo "Enter name of feature to run:"
read featName
echo "Running $featName..."
$featName


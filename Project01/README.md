# CS 1XA3 Project01 - yaol13

## Usage
Execute this script from the Project01 folder by entering the following commands:

    chmod +x project_analyze.sh
    ./project_analyze.sh

Note: This script is intended to run from the CS1XA3/Project01 directory, though it should still work as long as you are running it from within the CS1XA3 repo.

Once the script runs, you will be prompted to input the feature you want to use.
Simply enter in the name of the feature (listed in each feature's section below) you wish to run, then press enter.

## Feature Checkout Latest Merge
**Description**: This feature will locate the latest commit with the word "merge" in its commit message, 
and then automatically checkout that commit. Note: This will put you in a detached HEAD state, and is case-insensitive.

**Execution**: Input "checkout_latest_merge" (without the quotes) when prompted.

## Feature FIXME Log
**Description**: This feature will search for files within the CS1XA3 repo that contain "#FIXME" (case-sensitive) in their last line, and output their name (including the path to that file)
to "Project01/fixme.log". Files in the .git directory are ignored to avoid overlap.

**Execution**: Input "fixme_log" (without the quotes) when prompted.

**Reference**: 

1. Finding of fileList modified from https://unix.stackexchange.com/a/350090

## Feature File Type Count
**Description**: This feature will prompt the user for a file extension (e.g. "txt", "py", "log", etc.) and output the number of files in the CS1XA3 repo
of that file extension. If no extension is entered, the total number of files in the repo, including those in hidden directories (such as .git), will be output instead.

**Execution**: Input "file_type_count" (without the quotes) when prompted, press Enter, then input the file extension you wish to search for, if any.

## Feature Switch to Executable
**Description**: This feature will allow the user to add execute permissions to .sh files for users that already have write permissions, as well as allowing the user
to restore the original permissions of .sh files. When running this feature, the user is prompted on whether they want to "Change" or "Restore" permissions. If the user
selects "Change", the program will find all files with the ".sh" extension and allow users that have write permission to also execute the files. The files' original
permissions are then stored in "Project01/permissions.log" in octal format, along with a path to the file. If the user selects "Restore", the program will then restore
the original permissions of all files found in permissions.log. Please note that the permissions of "project_analyze.sh" will *not* be altered by this feature.
Additionally, please ensure that no file paths contain the ";" character, as this is used as a delimiter for permissions.log.

**Execution**: Input "switch_to_executable" (without the quotes) when prompted, then type either "change" or "restore" (case-insensitive) and press Enter.

**Reference**: 

1. Change string to lowercase from https://stackoverflow.com/a/27679748. 
2. Substring removal from https://linuxhint.com/bash_string_manipulation/

## Backup and Delete / Restore
**Description**: This feature will allow the user to back up temporary (".tmp") files found in the repo to "Project01/backup". Users may also restore these files
to their original location using this feature. When running this feature, the user is prompted on whether they want to "Backup" or "Restore" files. 

If the user chooses "Backup", the program will move all files with the ".tmp" extension to a backup folder in the Project01 directory. The files are renamed sequentially to account for the
possibility of duplicate file names. Additionally, a file called "restore.log" is created in the backups folder to keep track of each file's original path. Please do not tamper with this file or the backups folder.

If the user chooses "Restore", the program will restore the files in the backups folder to their original location using "restore.log". If this file doesn't exist, the program will throw an error and exit.

**Execution**: Input "backup_restore" (without the quotes) when prompted, then type either "backup" or "restore" (case-insensitive) and press Enter.

**Reference**: 
1. Change string to lowercase from https://stackoverflow.com/a/27679748. 

## Custom Feature HTML Template
**Description**: This feature will generate an html file from a template called "template.html" in the Project01 folder. If this file does not exist,
it will throw an error prompting the user to create one, and exit. If it does exist, the user will be prompted to enter the name of the new file, and a path to where
the new file should be. Once created, the script will replace any instances of the string "%NAME%" with the name of the file, in title case (e.g. "Abcd")

Note: Special characters in custom names may not appear properly in the file explorer. Additionally, you may want to leave file extensions out of your custom name.
If the custom path is invalid, the new HTML file will be placed in the Project01 folder. This feature *will* overwrite files that already exist, so be warned.

**Execution**: Input "html_template" (without the quotes) when prompted, then input a name for the new file, then input a path to where the file will be placed.

**Reference**:

1. String manupulation from https://linuxhint.com/bash_string_manipulation/

## Custom Feature Censor File
**Description**: This feature will check if there is a file named "forbidden-text.txt" in the Project01 folder of the repo. If this file doesn't exist, the 
script will throw an error and exit, prompting the user to create it. Otherwise, the script will prompt the user for a path to a file, and then prompt them
for a string. If the user does not enter a custom string, the script will replace any string in the user's file that matches any line in forbidden-text.txt
with "\[REDACTED]". Otherwise, it will just replace any forbidden text with the user's custom string, enclosed in square brackets. 
If a file named "censor_exclude.txt" exists, the script will throw an error if the path the user enters matches any line in this file (i.e. the script will not modify any files listed within).

Note: Please use relative paths without "./" if the file you wish to censor is in Project01 or a subdirectory, and use absolute paths for files elsewhere.
Additionally, you may want to leave punctuation out of "forbidden-text.txt". Please do not include slashes of any kind in "forbidden-text.txt" or your custom string.
Separate words in "forbidden-text.txt" using lines, not spaces (i.e. each line is treated as a word).

**Execution**: Input "censor_file" (without the quotes) when prompted, then input a path to a file, and any string, as prompted.

**Reference**:

1. String manupulation from https://linuxhint.com/bash_string_manipulation/
2. Case-insensitive sed matching from https://www.cyberciti.biz/faq/unixlinux-sed-case-insensitive-search-replace-matching/
# CS 1XA3 Project01 - yaol13

## Usage
    Execute this script from the Project01 folder with:
        chmod +x project_analyze.sh
        ./project_analyze.sh
    Once the script runs, you will be prompted to input the feature you want to use.
    Simply enter in the name of the feature (listed in each feature's section below) you wish to run, then press enter.

## Checkout Latest Merge
    Description: This feature will locate the latest feature with the word "merge" in its commit message, 
        and then automatically checkout that commit. Note: This will put you in a detached HEAD state.
    Execution: Input "checkout_latest_merge" (without the quotes) when prompted.

## FIXME Log
    Description: This feature will search for files that contain "#FIXME" in their last line, and output their name (including the path to that file)
        to "Project01/fixme.log". Files in the .git directory are ignored to avoid overlap.
    Execution: Input "fixme_log" (without the quotes) when prompted.

## File Type Count
    Description: This feature will prompt the user for a file extension (e.g. "txt", "py", "log", etc.) and output the number of files in the repo
        of that file extension. If no extension is entered, the total number of files in the repo, including those in the .git folder, will be output instead.
    Execution: Input "file_type_count" (without the quotes) when prompted, press Enter, then input the file extension you wish to search for.

## HTML Template (Custom Feature)
    Description: This feature will generate an html file from a template called "template.html" in the Project01 folder. If this file does not exist,
        it will prompt the user to create one and exit. If it does exist, the user will be prompted to enter the name of the new file, and a path to where
        the new file should be. Once created, the script will replace any instances of the string "%NAME%" with the name of the file, in title case (e.g. "Abcd")
    Execution: Input "html_template" (without the quotes) when prompted, then input a name for the new file, then input a path to where the file will be placed.
#!/bin/bash

featHello() {
	echo "Hello there"
}

checkout_latest_merge() {
	#TODO
	latestMerge=$(git log --oneline | grep -i "merge" | head -1 | cut -d " " -f1 )
	git checkout $latestMerge
	echo "Checked out commit $latestMerge"
}

echo "Enter name of feature to run:"
read featName
echo "Running $featName..."
$featName


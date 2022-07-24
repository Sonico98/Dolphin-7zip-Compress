#!/bin/bash
# Ask for a file name if multiple files are selected
if [[ "$#" -gt 2 ]]; then
	echo "How would you like to name the archive?"
	read -r -p "Archive name (without extension): " archivename
	while [[ "$archivename" = "" ]]; do
		echo ""
		read -r -p "The name can't be empty. Try again: " archivename
	done
# If it's a single file or folder, create an archive with its name
else 
	origfname=$(rev <<< "$2" | cut --complement -d"/" -f2- | rev)
	if [[ -f "$2" ]]; then
		archivename=$(rev <<< "$origfname" | cut -d"." -f2- | rev)
	# If it's a folder, don't try to remove a file's extension
	else
		archivename="$origfname"
	fi

	# Make sure we don't end up with an unnamed file
	if [[ "$archivename" = "" ]]; then
		archivename="$origfname"
	fi
fi

# Be absolutely sure there won't be file conflicts
ct=0
while [[ -e "$archivename".7z || -e "$archivename".zip ]]; do
	ct=$((ct+1))
	archivename="$archivename"\ "($ct)"
done

# Process the options passed to the script
while getopts ":sdu:" option; do
	case $option in
		s) # Store
			7z -tzip -m0=Copy a "$archivename".zip "${@:2}"
			exit;;
		d) # Divide into 2GB files
			7z -t7z -v2097152000b -m0=Copy a "$archivename".7z "${@:2}"
			exit;;
		u) # Ultra compression
			7z -t7z -m0=lzma2:d1024m -mx=9 -mfb=256 -md=128m -ms=on a "$archivename".7z "${@:2}"
			exit;;
		\?) # Invalid option
			echo "Error: Invalid option"
			exit;;
	esac
done

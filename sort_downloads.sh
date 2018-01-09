#!/bin/bash

HPATH='/home/david'
DPATH=$HPATH/Downloads

DOCUMENT=("pdf" "xlsx" "docx" "doc" "tex" "txt");
PICTURE=("jpg" "png" "gif" "gifv");
COMPRESSED=("zip" "deb" "tar.gz" "tar.xz");
MUSIC=("mp3" "mid" "flac" "wav")
VIDEO=("mp4" "avi" "webm" "flv")

RESERVED=('Documents' 'Compressed' 'Pictures' 'Other')

function search() {
	name=$1[@]
	a=("${!name}")

	for EXT in "${a[@]}"; do
		find $DPATH -maxdepth 1 -type f -name '*.'$EXT -exec mv -n {} $2 \;
	done
}

search DOCUMENT $DPATH/Documents
search PICTURE $HPATH/Pictures
search VIDEO $HPATH/Videos
search MUSIC $HPATH/Music
search COMPRESSED $DPATH/Compressed

find $DPATH -maxdepth 1 -type f -exec mv -n {} $DPATH/Other \;

for DIR in $DPATH/*
do
	VALID=true
	for NAME in $RESERVED
	do
		if [ "$DIR" \< $NAME ]
		then
			VALID=false
			break
		fi
	done
	if $VALID
	then
		mv "$DIR" Other
	fi
done

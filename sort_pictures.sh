#!/bin/bash

DPATH='/home/david/Pictures'
HPATH='/home/david/Scripts'

OIFS="$IFS"
IFS=$'\n'

function move() {
	find $DPATH -maxdepth 1 -type f -name "$1*" -exec mv -n {} $DPATH/$2 \;
	for FILEA in $DPATH/$1*
	do
		for FILEB in $DPATH/$2/*
		do
			cmp --silent $FILEA $FILEB && rm $FILEA
			echo "$FILEA $FILEB"
		done
	done
	unset COUNT
	while [ "$(find $DPATH -maxdepth 1 -type f -name "$1" )" ]
	do
		find $DPATH -maxdepth 1 -type f -name "$1" -exec sh -c 'mv "$1" "${1%'$COUNT'.*}'$(( COUNT + 1 ))'.${1##*.}"' _ {} \;
		find $DPATH -maxdepth 1 -type f -name "$1" -exec mv -n {} $DPATH/$2 \;
		COUNT=$((COUNT+1))
	done
}

move 'Screenshot*' Screenshots
move 'Selection*' Screenshots

find $DPATH -maxdepth 1 -type f -exec echo {} > $HPATH/sort_pictures.log \;

while read FILE
do
	WIDTH=$(identify -format '%w' $FILE)
	HEIGHT=$(identify -format '%h' $FILE)
	SIZE=$(stat --printf="%s" $FILE)
	if [[ $WIDTH -gt 1500 && $HEIGHT -gt 700 ]]
	then
		FILE=${FILE##*/}
		FILE=${FILE%.*}
		echo $FILE
		move $FILE Wallpapers
	fi
done < $HPATH/sort_pictures.log

move '*_*' Other
move '*-*' Other
move '*' Memes

IFS="OIFS"

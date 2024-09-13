#!/bin/bash

clear

path="$1"

if [[ $path != "$HOME"/* ]]; then
	echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2
	exit 1
fi

while true; do

  echo "$(ls -p "$path" | grep -v /)"
	read -p "You are going to save each file in a separate directory, is that correct? (y/n):" answer
	if [[ $answer == 'y' || $answer == 'Y' ]]; then
		break
	elif [[ $answer == 'n' || $answer == 'N' ]]; then
		exit 1
	fi
	clear
	echo "Invalid answer: Try Again"
done

ls -p "$path" | grep -v / | while IFS= read -r file; do

  file_name="${file%.*}" 
  mkdir "$path"/"$file_name"
  mv "$path"/"$file" "$path"/"$file_name"

done

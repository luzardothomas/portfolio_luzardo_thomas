#!/bin/bash

clear

path="$1"
template="$2"

if [[ $path != "$HOME"/* ]]; then
	echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2
	exit 1
fi

if [[ ! -n "$template" ]]; then
    echo -e "Error 2: Template can't be void"
    exit 1
fi 

while true; do

  echo "$(ls -p "$path" | grep -v /)"
	read -p "You are going to change those file's name to $template is that correct? (y/n):" answer
	if [[ $answer == 'y' || $answer == 'Y' ]]; then
		break
	elif [[ $answer == 'n' || $answer == 'N' ]]; then
		exit 1
	fi
	clear
	echo "Invalid answer: Try Again"
done

count=1

ls -p "$path" | grep -v / | while IFS= read -r file; do
  extension="${file##*.}"

  new_file="${template}${count}"

  if [[ "$file" == *.* ]]; then
    new_file="${new_file}.${extension}"
  fi

  mv -- "$path"/"$file" "$path"/"$new_file" > /dev/null 2>&1

  ((count++))
  
done







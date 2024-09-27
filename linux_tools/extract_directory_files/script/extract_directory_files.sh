#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'extract_directory_files --help' for more information."
	exit 1
fi
if [[ $1 == '--help' ]]; then
	echo "extract_directory_files [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Extracts all the files from each directory"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Creates a merge directory"
	echo "2- Extracts all files from each directory"
	echo "3- Stores the extracted files in the merge directory"
	echo "Repeats the last three steps until all directories haven been extracted"       
	echo
	echo "Inside the brackets [], there are comments"
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Syntax for running the script:"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo
	echo "=============================================================="
	echo "script_name path [opt] skip_command [opt] directory_name [req]"
	echo "=============================================================="
	echo
	echo "[req = required]"
	echo "[opt = optional]" 
	echo
	echo "++++++++++++++++++++++++++++++"
	echo "Characteristics of the script:"
	echo "++++++++++++++++++++++++++++++"
	echo
	echo "* Path must include $HOME/"
	echo "* The directory name is where you will save all the files"
	echo "* The directory name don't accept spaces"
	echo "* The directory can't exist before its creation"
	echo
	echo "After # there are comments"
	echo
	echo "###############"
	echo "Ways to use it:"
	echo "###############"
	echo
	echo "extract_directory_files ~/path directory_name"
	echo "# files found will be stored in that directory"
	echo
	echo "extract_directory_files directory_name"
	echo "# no path means current path"
	echo 
	echo "extract_directory_files -sk directory_name"
	echo "# sk means skip question"
	exit 1
fi

path="$1"

if [[ $1 != /* ]]; then
	path=$(pwd)
else
	shift
fi

if [[ $path != "$HOME"/* ]]; then
  echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2   
	exit 1
fi

if [[ $1 == '-sk' ]]; then
	answer="y"
	shift
fi

invalid_chars='[\/:*?"<>|]'

if [[ -z $1 || "$1" =~ $invalid_chars ]]; then
	echo -e "\e[31mError 2: Invalid directory name.\e[0m" >&2   
	exit 1
else
	to="$1"
	shift
fi

if [ ! -d "$path"/"$to" ]; then
	mkdir "$path"/"$to"
else
	echo -e "\e[31mError 3: That directory already exists.\e[0m" >&2   
	exit 1
fi

cd "$path"

directories=$(ls -d */ | grep -Ev "("$to"/)$")

if [[ -z $directories ]]; then
	echo -e "\e[31mError 4: There aren't any directories.\e[0m" >&2   
	exit 1
fi

while true; do
  if [[ ! -n "$answer" ]]; then
  	echo "$directories"
    echo "You are about to extract all files from those directories in '$path'."
    read -p "Is this correct? (y/n): " answer
  fi
  
  if [[ $answer == 'y' ||  $answer == 'Y' ]]; then
    break
  elif [[ $answer == 'n' || $answer == 'N' ]]; then
    exit 1
  fi
  
  clear
  
  echo "Invalid answer: Try Again"
  
  answer=""
done

file_count=0

IFS=$'\n'

for directory in $directories; do

	lines=$(find "$path"/"$directory" -type f | sort -V)

	for line in $lines; do
    file=$(basename "$line")
    file_count=$((file_count+1))
    base_name="${file%.*}" 
		extension="${file##*.}"
		new_file=""$base_name"_"$file_count"."$extension""
		echo "File found: $file"
		mv "$line" "$path"/"$to"/"$new_file"
	done
	
	rm -r "$path"/"$directory"
	
done








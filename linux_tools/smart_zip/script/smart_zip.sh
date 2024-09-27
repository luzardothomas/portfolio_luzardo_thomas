#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'smart_zip --help' for more information."
	exit 1
fi

if [[ $1 == '--help' ]]; then
	echo "smart_zip [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Compress each directory in a format .zip"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Creates a merge directory used to store the results after the loop"
	echo "2- Compresses a single directory into a .zip file"
	echo "3- Erases the original directory"
	echo "Repeats the last two steps until the end"
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
	echo "* The directory name is where you will save all the .zip files"
	echo "* The directory name don't accept spaces"
	echo "* The directory can't exist before its creation"
	echo
	echo "After # there are comments"
	echo
	echo "###############"
	echo "Ways to use it:"
	echo "###############"
	echo
	echo "smart_zip ~/path directory_name"
	echo "# creates a merge directory used to store all"
	echo "# the .zip files created from the directories"
	echo
	echo "smart_zip directory_name"
	echo "# no path means current directory"
	echo
	echo "smart_zip -sk directory_name"
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

directories=$(ls -d */ | grep -Ev "("$to"/)$" | sort -V)

if [[ -z "$directories" ]]; then
	echo -e "\e[31mError 4: There are no directories.\e[0m" >&2
	exit 1
fi

while true; do
	
  if [[ ! -n "$answer" ]]; then
    echo "$directories"
    echo "You are about to compress each directory."
    read -p "Is this correct? (y/n): " answer
  fi
  
  if [[ $answer == 'y' || $answer == 'Y' ]]; then
    break
  elif [[ $answer == 'n' || $answer == 'N' ]]; then
    exit 1
  fi
  clear
  echo "Invalid answer: Try Again"
  answer=""
  
done

IFS=$'\n'

for directory in $directories; do
	directory="${directory%/}"
	zip_file="$path"/"$directory.zip"
	
  echo "Compressing '$directory' into '$directory.zip'"
  zip -r "$zip_file" "$path/$directory/" > /dev/null 2>&1
  echo "Moving the '$directory.zip' to '$to'"
  mv "$zip_file" "$path"/"$to"
  echo "Erasing the original directory '$directory'"
  rm -r "$path"/"$directory"
    
done





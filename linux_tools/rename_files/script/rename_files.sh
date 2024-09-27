#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'rename_files --help' for more information."
	exit 1
fi

if [[ $1 == '--help' ]]; then
	echo "rename_files [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Renames all file names using a template"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Separate the files to be processed in ascending order"
	echo "2- Process the files in ascending order"
	echo "3- Get the file extension"
	echo "4- The new file name will follow this format:"
	echo "   * template ; counter ; extension"
	echo "5- Rename the file with the new name"
	echo "Repeats the last three steps until all files have been processed"   
	echo
	echo "Inside the brackets [], there are comments"
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Syntax for running the script:"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo
	echo "=================================================================="
	echo "script_name path [opt] skip_command [opt] template_name [req]"
	echo "=================================================================="
	echo
	echo "[req = required]"
	echo "[opt = optional]"
	echo 
	echo "++++++++++++++++++++++++++++++"
	echo "Characteristics of the script:"
	echo "++++++++++++++++++++++++++++++"
	echo
	echo "* Path must include $HOME/"
	echo "* The template is the base name used for renaming all the files"
	echo "* The template don't accept spaces"
	echo "* The template can't be the same as the original file"
	echo
	echo "###############"
	echo "Ways to use it:"
	echo "###############"
	echo
	echo "rename_files ~/path template"
	echo "# use a template to rename all the files"
	echo    
	echo "rename_files template"
	echo "# no path means current directory"
	echo
	echo "rename_files -sk template"
	echo "# sk means skip question"
	exit 1
fi

path="$1"

if [[ "$1" != /* ]]; then
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
	echo -e "\e[31mError 2: Invalid template name.\e[0m" >&2   
	exit 1
else
	template="$1"
	shift
fi

files=$(ls -p "$path" | grep -v / | sort -V)

if [[ -z $files ]]; then
	echo -e "\e[31mError 3: There are no files in your Directory.\e[0m" >&2
  exit 1
fi
	
while true; do
	
  if [[ ! -n "$answer" ]]; then
  	echo "$files"
    echo "You are going to rename those files to '$template'."
    read -p "Is this correct? (y/n):" answer
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

count=1

IFS=$'\n'

for file in $files; do

	extension="${file##*.}"
  new_file="${template}${count}.${extension}"
  base_name=""
  
  if [[ $file == $new_file ]]; then
  	echo -e "\e[31mError 4: Same template.\e[0m" >&2
  	exit 1
  fi
  
  echo "$file renamed to $new_file"
  mv "$path"/"$file" "$path"/"$new_file"
  ((count++))
done







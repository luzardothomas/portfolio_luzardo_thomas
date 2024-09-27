#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'wrap_files --help' for more information."
	exit 1
fi

if [[ $1 == '--help' ]]; then
	echo "wrap_files [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Stores each file in a directory created with the same name"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Creates a merge directory"
	echo "2- Creates a file directory"
	echo "3- Moves the file to the file directory"
	echo "4- Moves the file directory to the merge directory"
	echo "Repeats the last four steps until the end"  
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
	echo "* The directory name is where you will save all the directories"
	echo "  which contains the single files"
	echo "* The directory can't exist before its creation"
	echo "* The directory name don't accept:"
	echo "	- Spaces (Whatever you write will be ignored)"
	echo "	- Void"
	echo "	- / (slash)"
	echo "	- \\ (backslash)"
	echo "	- : (two dots)"
	echo "	- * (asterisk)"
	echo "	- ? (question mark)"
	echo "	- \" (double quotes)"
	echo "	- < (less than)"
	echo "	- > (greater than)"
	echo "	- | (pipe)"
	echo
	echo "After # there are comments"
	echo
	echo "###############"
	echo "Ways to use it:"
	echo "###############"
	echo
	echo "wrap_files ~/path directory_name"
	echo "# creates a directory used to store each of the"
	echo "# directories created to contain the single files"
	echo
	echo "wrap_files directory_name"
	echo "# no path means current directory"
	echo
	echo "wrap_files -sk directory_name"
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

files=$(ls -p "$path" | grep -v /)

if [[ -z "$files" ]]; then
	echo -e "\e[31mError 2: There are no files.\e[0m" >&2
	exit 1
fi

invalid_chars='[\/:*?"<>|]'

if [[ -z $1 || "$1" =~ $invalid_chars ]]; then
	echo -e "\e[31mError 3: Invalid directory name.\e[0m" >&2   
	exit 1
else
	to="$1"
	shift
fi

if [ ! -d "$path"/"$to" ]; then
	mkdir "$path"/"$to"
else
	echo -e "\e[31mError 4: That directory already exists.\e[0m" >&2   
	exit 1
fi

while true; do
	
  if [[ ! -n "$answer" ]]; then
    echo "$files"
    echo "You are about to wrap each file in a different directory."
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

for file in $files; do
	file_name="${file%.*}" 
  
  if [[ -d "$path"/"$file_name" ]]; then
		echo -e "\e[31mError 5: A directory called $file_name already exists.\e[0m" >&2
		exit 1
	fi
	echo "Directory '$file_name' created"
  mkdir "$path"/"$file_name"
  echo "Moving '$file' to '$file_name' directory"
  mv "$path"/"$file" "$path"/"$file_name"
  echo "Moving '$file_name' directory to merge directory '$to'"
  mv "$path"/"$file_name" "$path"/"$to"
done


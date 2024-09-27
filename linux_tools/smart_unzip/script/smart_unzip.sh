#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'smart_unzip --help' for more information."
	exit 1
fi

if [[ $1 == '--help' ]]; then
	echo "smart_unzip [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Extracts all the files of each .zip"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Creates a merge directory used to store the results after the loop"
	echo "2- Extracts files from a single .zip file"
	echo "3- Erases the original .zip file"
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
	echo "* The directory name is where you will save all the files"
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
	echo "smart_unzip ~/path directory_name"
	echo "# files will be stored in that directory"
	echo
	echo "smart_unzip directory_name"
	echo "# no path means current path"
	echo
	echo "smart_unzip -sk directory_name"
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

zips=$(ls -p "$path" | grep -v / | grep "\.zip$")

if [[ -z "$zips" ]]; then
	echo -e "\e[31mError 3: There are no .zip files.\e[0m" >&2
	exit 1
fi

while true; do
	
  if [[ ! -n "$answer" ]]; then
    echo "$zips"
    echo "You are about to unzip and erase all the these .zip files."
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

for zip in $zips; do
	unzip -jo "$path"/"$zip" -d "$path"/"$to" > /dev/null 2>&1
	rm -r "$path"/"$zip"
	echo "The package '"$zip"' was successfully unzipped in '$to'"
done


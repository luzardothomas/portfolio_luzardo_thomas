#!/bin/bash

if [[ -z $@ ]]; then
	echo "Try 'wrap_files_in_groups --help' for more information."
	exit 1
fi

if [[ $1 == '--help' ]]; then
	echo "wrap_files_in_groups [script]"
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo "Summary of how the script works:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "Stores groups of files in a directory"
	echo
	echo "::::::::::::::::::::::"
	echo "Process of the script:"
	echo "::::::::::::::::::::::"
	echo
	echo "1- Separate the files in ascending order"
	echo "2- Select a range of files"
	echo "3- Create a directory for a group of files"
	echo "4- Move the range of files to their corresponding group"
	echo "Repeats the last three steps until there are no more ranges" 
	echo
	echo "Inside the brackets [], there are comments"
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Syntax for running the script:"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo
	echo "======================================================================="
	echo "script_name path [opt] skip_command [opt] group_name [opt] ranges [req]"
	echo "======================================================================="
	echo
	echo "[req = required]"
	echo "[opt = optional]"
	echo
	echo "++++++++++++++++++++++++++++++"
	echo "Characteristics of the script:"
	echo "++++++++++++++++++++++++++++++"
	echo
	echo "* Path must include $HOME/"
	echo "* Range syntax is a-b (both numbers)"
	echo "* Range can't be greater than the number of files"
	echo "* Range calculus is range = b - a + 1 and the result must be positive"
	echo "* Range is the number of files that you want to select"
	echo "* Each range is a group, for example:"
	echo "  1-2 3-6 7-10 (three groups: first 2 files, second 4 files, third 4 files)"
	echo "* The directory name could be a template or a group name, it depends on the option chosen"
	echo "* Option 1: group name acts as a template | Option 2: group name"
	echo "* The template must be just one"
	echo "* Group name can be more than one directory's name, and the number"
	echo "  of group names must the same as the number of groups"
	echo "* The group can't exist before its creation"
	echo "* The group name don't accept:"
	echo "	- Spaces (Whatever you write after space is another group)"
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
	echo "wrap_files_in_groups ~/path 1-10"
	echo "# Selects a group of 10 files, and then the user must"
	echo "# choose between option 1 (template) or option 2 (group name),"
	echo "# both options act the same because they refer to the same range."
	echo
	echo "wrap_files_in_groups 1-10"
	echo "# no path means current directory"
	echo
	echo "wrap_files_in_groups -sk1 1-2 3-6 7-10"
	echo "# sk1 means skip the question and choose option 1"
	echo "# the template is only one and will be requested on screen"
	echo "# template = example_name, there are 3 groups (1-2,3-6,7-10)"
	echo "# example_name_1: 2 files, example_name_2: 4 files, example_name_3: 4 files"
	echo
	echo "wrap_files_in_groups -sk1 group_name 1-2 3-6 7-10"
	echo "# group_name_1: 2 files, group_name_2: 4 files, group_name_3: 4 files"
	echo
	echo "wrap_files_in_groups -sk2 1-2 3-6 7-10"
	echo "# sk2 means skip the question and choose option 2"
	echo "# use group_name as specific names for groups, requested on screen"
	echo "# number of group names = number of group"
	echo "# there are 3 groups (1-2,3-6,7-10), so you need to input three group_name"
	echo "# group_name_1 = groupA, group_name_2 = groupB, group_name_3 = groupC"
	echo "# groupA_1: 2 files, groupB_2: 4 files, groupC_3: 4 files"
	echo
	echo "wrap_files_in_groups -sk2 group_name_A group_name_B group_name_C 1-2 3-6 7-10"
	echo "# groupA_1: 2 files, groupB_2: 4 files, groupC_3: 4 files"
	exit 1
fi

path="$1"

if [[ $1 != /* ]]; then
	path=$(pwd)
else
	shift
fi

if [[ $path != "$HOME"/* ]] ; then
	echo -e "\e[31mError 1: Path doesn't include '$HOME/'.\e[0m" >&2
	exit 1
fi

file_count=$(ls -p "$path" | grep -v / | sort -V | wc -l)

if [[ $file_count == 0 ]]; then
	echo -e "\e[31mError 2: There aren't any files.\e[0m" >&2
	exit 1
fi

invalid_chars='[\/:*?"<>|]'

if [[ $1 == '-sk1' ]] || [[ $1 == '-sk2' ]]; then
	answer="y"
	option=$(echo "$1" | grep -o '[0-9]\+$')
	shift

	group_name=0
	dir_auto=()
	
	while [[ ! "$1" =~ ^[0-9]+-[0-9]+$ ]] && [[ -n "$1" ]]; do
	
		if [[ $1 =~ $invalid_chars ]]; then
			echo -e "\e[31mError 2: Invalid group name.\e[0m" >&2
			exit 1
		fi
		
		dir_auto+=("$1")
		group_name=$((group_name+1))
		shift
	done
	
	if [[ $group_name != 0 ]]; then

		if [[ $option == 1 ]]; then
		
			if [[ $group_name != 1 ]]; then
				echo -e "\e[31mError 3: Template must be one.\e[0m" >&2
				exit 1
			fi
			
		else
				
			if [[ $group_name != $# ]]; then
				echo -e "\e[31mError 4: Number of group names must be equal to the number of groups.\e[0m" >&2
				exit 1
			fi
			
		fi
		
	fi
	
fi

ranges=()
params=("$@")
range_count=0

function validate_and_count_range {
	count=0
	
	for param in "${params[@]}"; do
		  if [[ "$param" =~ ^([0-9]+)-([0-9]+)$ ]]; then
		    numero1="${BASH_REMATCH[1]}"
		    numero2="${BASH_REMATCH[2]}"
		    range=$((numero2 - numero1))
		    
		    if [[ $range -lt 0 ]]; then
		    	echo -e "\e[31mError 5: Range negative.\e[0m" >&2
    			exit 1
		    fi
		    
		    range=$((range+1))
		    
		    ranges+=("$range")
		    
		    count=$((count + range))
		  else
		  	echo -e "\e[31mError 6: Range '$param' ins't valid.\e[0m" >&2
    		exit 1  
		  fi  
	done
	range_count=$count
}

validate_and_count_range

if [[ $range_count == 0 ]]; then
	echo -e "\e[31mError 7: Range can't be void.\e[0m" >&2
	exit 1
fi

if [[ $range_count -gt $file_count ]]; then
	echo -e "\e[31mError 8: Range greater than real number of files.\e[0m" >&2
	exit 1
fi

files=$(ls -1 -p "$path" | grep -v / | sort -V)

while true; do
	if [[ ! -n $answer ]]; then
		echo "$files"
		echo "Path sent: '$path'"
		echo "You are going to move one or more of the $file_count files"
		echo "Each file that you choose will be stored in one or more directory"
		read -p "Is that correct? (y/n):" answer
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

while true; do
  if [[ -n "$option" ]]; then
  	shift
  else
		echo "Option 1: Choose a template for group name"
		echo "Option 2: Specify each group name"
		read -p "Option:" option
  fi
	
	if [[ $option == 1 || $option == 2 ]]; then
		break
	fi
	
	clear
	
	echo "Invalid answer: Try Again"
	option=""
	
done

function move_groups {

	count=$((count+1))
	dir_name=""$dir"_"$count""
	
	if [[ -d "$path"/"$dir_name" ]]; then
		echo -e "\e[31mError 9: A directory called $dir_name already exists.\e[0m" >&2
		exit 1
	fi
	
	mkdir "$path"/"$dir_name"

	ranges=("${ranges[@]:1}")
	dir_auto=("${dir_auto[@]:1}")

	while [[ $iterations -gt 0 ]]; do
		file=$(echo "$files" | head -n 1)
		files=$(echo "$files" | sed '1d')
		mv "$path"/"$file" "$path"/"$dir_name"
		iterations=$((iterations-1))
		echo "The file $file was wrapped in '$dir_name'"
	done

}

count=0

if [[ $option == 1 ]]; then
	if [[ ! -n $dir_auto ]]; then
		while true; do
			echo "================= OPTION 1 ================="
			read -p "Write a template for directory names:" dir
			if [[ ! -n $dir || $dir =~ $invalid_chars ]]; then
				clear
				echo "Invalid directory name: Try Again"
			else
				break
			fi
		done
	fi
	
	while true; do
	
		iterations="${ranges[0]}"
		
		if [[ -n $dir_auto ]]; then
			dir="${dir_auto[0]}"
		fi

		if [ ${#ranges[@]} -eq 0 ]; then
			break
		fi
		
		move_groups
		    
	done
	
else

	range_collection=${#ranges[@]}
	
	while true; do
		
		if [[ ! -n "$dir_auto" ]]; then
			while true; do
				echo "================= OPTION 2 ================="
				read -p "Write a directory name ($((count+1))/$range_collection):" dir
				if [[ ! -n "$dir" || $dir =~ $invalid_chars ]]; then
					clear
					echo "Invalid directory name: Try Again"
				else
					break
				fi
				
			done
	  else
	  	dir="${dir_auto[0]}"
	  fi
	  
	  	iterations="${ranges[0]}"
	  	 
	  	if [ ${#ranges[@]} -eq 0 ]; then
				break
			fi
	  
	  	move_groups
	  		
			if [[ $count -eq $range_collection ]]; then
				break
			fi
	  
	done
fi



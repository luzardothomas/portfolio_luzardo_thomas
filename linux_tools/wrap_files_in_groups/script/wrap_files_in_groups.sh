#!/bin/bash

clear

path="$1"

if [[ $path != "$HOME"/* ]]; then
	echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2
	exit 1
fi

shift

if [ $# -eq 0 ]; then
  echo -e "\e[31mError 2: Ranges can't be void.\e[0m" >&2
  exit 1
fi

file_count=$(ls -p "$path" | grep -v / | sort -V | tee /dev/tty | wc -l)

if [[ $file_count == 0 ]]; then
	echo -e "\e[31mError 3: There aren't any files.\e[0m" >&2
	exit 1
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
		    range=$((numero2 - numero1 + 1))
		    
		    ranges+=("$range")
		    
		    count=$((count + range))
		  else
		  	echo -e "\e[31mError 4: Range '$param' ins't valid.\e[0m" >&2
    		exit 1  
		  fi  
	done
	range_count=$count
}

validate_and_count_range

if [[ $range_count -gt $file_count ]]; then
	echo -e "\e[31mError 5: Range greater than file quantity.\e[0m" >&2
	exit 1
fi

while true; do
	echo "Path sent: '$path'"
  read -p "You are going to save $file_count files in one or more directories, is that correct? (y/n)" answer
  
	if [[ $answer == 'y' || $answer == 'Y' ]]; then
		break
	elif [[ $answer == 'n' || $answer == 'N' ]]; then
		exit 1
	fi
	
	clear
	echo "Invalid answer: Try Again"
	
done

while true; do
  echo "Option 1: Choose a generic directory name"
  echo "Option 2: Specify each directory name"
  read -p "Option:" answer
  
  if [[ $answer == 1 || $answer == 2 ]]; then
		break
	fi
	
	clear
	
	echo "Invalid answer: Try Again"
	
done

function move_groups {
	
	dir_name=""$dir"_"$(($count+1))""
	mkdir "$path"/"$dir_name"

	ranges=("${ranges[@]:1}")

	while [[ $iterations -gt 0 ]]; do
		file="$(ls -1 -p "$path" | grep -v / | sort -V | head -n 1)"
		mv "$path"/"$file" "$path"/"$dir_name"
		iterations=$((iterations-1)) 	
	done

	count=$((count+1))

}

count=0

if [[ $answer == 1 ]]; then
	while true; do
		read -p "Write the generic directory name:" dir
		if [[ ! -n "$dir" ]]; then
    	echo "Directory can't be void. Try again"
    else
			
			
    	while true; do
    		
    		iterations="${ranges[0]}"

				if [ ${#ranges[@]} -eq 0 ]; then
					break
				fi
    		
    		move_groups
		    
    	done
    	
    	break
		fi 
	done
	
else

	range_quantity=${#ranges[@]}
	
	while true; do
	
		read -p "Write a directory name ($((count+1))/$range_quantity):" dir
		
		if [[ ! -n "$dir" ]]; then
	  	echo "Error: Directory can't be void"
	  else
	  
	  	iterations="${ranges[0]}"
	  
	  	if [ ${#ranges[@]} -eq 0 ]; then
				break
			fi
	  
	  	move_groups
	  		
		fi
		 
		if [[ $count -eq $range_quantity ]]; then
	  	break
	  fi
	  
	done
fi



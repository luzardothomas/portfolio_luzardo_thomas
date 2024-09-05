#!/bin/bash

clear

current=$(pwd)

if [[ $current != "$HOME"/* ]]; then
  echo -e "\e[31mFor security the script only could be run in a Direction which includes '$HOME'.\e[0m" >&2   
	exit 1
fi

to=$(cd "$current/.." && pwd)

if [ ! -d "$to"/merge ]; then
	mkdir "$to"/merge
fi

while true; do

  result=$(ls -1 "$to" | grep -v '^script$' | grep -v '^merge$')
  
  if [ -z "$result" ]; then
  	exit 0
  fi
  
	ls -1 "$to" | grep -v '^script$' | grep -v '^merge$' | while IFS= read -r directory; do
		
		cd "$to"/"$directory"
		
		condition=$(ls -d */ > /dev/null 2>&1)
		
		if [ $? -eq 0 ]; then
			
			i=1
			
			condition=$(ls -d */)	
			condition=$(echo "$condition" | sed 's:/::')
			
			while CONTENT= read -r content; do

				for item in "$(pwd)"/"$content"/*; do
				  item_name=$(basename "$item")
					base_name="${item_name%.*}" 
					extension="${item_name##*.}" 
					
					if [[ "$item_name" == "$base_name" ]]; then
						mv "$to"/"$directory"/"$content"/"$base_name" "$to"/"$directory"/"$content"_$i""
					else
					  echo "Data found: '$item_name'"
						new_name="${base_name}_$i.$extension"
						mv "$item" "$to/$directory/$new_name"
					fi
					
					i=$((i+1))
					
				done

				rmdir "$to"/"$directory"/"$content" 
				
			done <<< "$condition"
					
		else
		
			mv "$(pwd)"/* "$to"/merge
			rmdir "$to"/"$directory"		 
			exit 0
			
		fi
		
	done
	
done







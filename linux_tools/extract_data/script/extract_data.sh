#!/bin/bash

clear

path=("$1")

if [[ $path != "$HOME"/* ]]; then
  echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2   
	exit 1
fi

if [ ! -d "$path"/merge ]; then
	mkdir "$path"/merge
fi

while true; do

  result=$(ls -1 "$path" | grep -v '^script$' | grep -v '^merge$')
  
  if [ -z "$result" ]; then
  	break
  fi
  
	ls -1 "$path" | grep -v '^script$' | grep -v '^merge$' | while IFS= read -r directory; do
		
		cd "$path"/"$directory"
		
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
						mv "$path"/"$directory"/"$content"/"$base_name" "$path"/"$directory"/"$content"_$i""
					else
					  echo "Data found: '$item_name'"
						new_name="${base_name}_$i.$extension"
						mv "$item" "$path/$directory/$new_name"
					fi
					
					i=$((i+1))
					
				done

				rmdir "$path"/"$directory"/"$content" 
				
			done <<< "$condition"
					
		else
		
			mv "$(pwd)"/* "$path"/merge
			rmdir "$path"/"$directory"		 
			break
			
		fi
		
	done
	
done







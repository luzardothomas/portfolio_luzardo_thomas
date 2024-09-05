#!/bin/bash

clear

current=$(pwd)

if [[ $current != "$HOME"/* ]]; then
  echo -e "\e[31mFor security the script only could be run in a Direction which includes '$HOME'.\e[0m" >&2   
	exit 1
fi

to=$(cd "$current/.." && pwd)

if [ ! -d "$to"/zips ]; then
  echo -e "\e[31mYou must save .zip files in the zips's directory otherwize the script won't work.\e[0m" >&2    
	mkdir "$to"/zips
  exit 1
fi

if [ ! -d "$to"/merge ]; then    
	mkdir "$to"/merge
fi

zip=$(cd "$to/zips" && pwd)

find "$zip" -type f -name "*.zip" | while IFS= read -r unzipped; do
  unzip -Z1 "$unzipped" | grep -v '/$' | while IFS= read -r file; do
    unzip -jo "$unzipped" "$file" -d "$to"/merge > /dev/null 2>&1;
  done
  rm -r "$unzipped"
  package=$(basename "$unzipped")
  echo "The package '"$package"' was successfully unzipped into '"$to/merge"'";
done

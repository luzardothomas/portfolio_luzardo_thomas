#!/bin/bash

clear

path="$1"

if [[ $path != "$HOME"/* ]]; then
  echo -e "\e[31mError 1: Path doesn't include '$HOME'.\e[0m" >&2   
	exit 1
fi

if [ ! -d "$path"/merge ]; then    
	mkdir "$path"/merge
fi

data=$(echo "$(find "$path" -type f -name "*.zip")")

if [[ -z "$data" ]]; then
	echo -e "\e[31mError 3: There are no .zip files.\e[0m" >&2
	exit 1
fi

find "$path" -type f -name "*.zip" | while IFS= read -r unzipped; do
  unzip -Z1 "$unzipped" | grep -v '/$' | while IFS= read -r file; do
    unzip -jo "$unzipped" "$file" -d "$path"/merge > /dev/null 2>&1;
  done
  rm -r "$unzipped"
  package=$(basename "$unzipped")
  echo "The package '"$package"' was successfully unzipped into '"$path/merge"'";
done

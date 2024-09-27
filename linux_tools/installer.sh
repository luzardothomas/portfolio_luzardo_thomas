#!/bin/bash

path=$(pwd)

while true; do
	clear
  cd "$path"
  
  echo "1- Install"
  echo "2- Uninstall"
  echo "3- Reinstall everything"
  echo "0- Exit"
  
  read -p "Select option:" option
  
  if [[ $option == 1 ]]; then
    clear
    echo "[install scripts]"
    echo "1- extract_directory_files"
    echo "2- rename_files"
    echo "3- smart_unzip"
    echo "4- smart_zip"
    echo "5- wrap_files"
    echo "6- wrap_files_in_groups"
    echo "7- Install all of them"
    echo "0- Back"
    
    read -p "Select option:" install_scripts
    
    case $install_scripts in
		  "1") script_path="$path/extract_directory_files/script" ;;
		  "2") script_path="$path/rename_files/script" ;;
		  "3") script_path="$path/smart_unzip/script" ;;
		  "4") script_path="$path/smart_zip/script" ;;
		  "5") script_path="$path/wrap_files/script" ;;
		  "6") script_path="$path/wrap_files_in_groups/script" ;;
		  "7") scripts=("extract_directory_files"
		                "rename_files"
		                "smart_unzip"
		                "smart_zip"
		                "wrap_files"
		                "wrap_files_in_groups") ;;
		  "0") continue ;;
		  *) clear; echo -n "Invalid option: Press enter to continue"; read; continue ;;
    esac
    
    if [[ $install_scripts == "7" ]]; then
    	clear
      for script in "${scripts[@]}"; do
      	cd "$path/$script/script"
      	bash install.sh	       
      done
 
    else
      clear
      cd "$script_path"
      bash install.sh
    fi

    echo -n "Press enter to continue."
    read 
    clear
  elif [[ $option == 2 ]]; then
    clear
    echo "[uninstall scripts]"
    echo "1- extract_directory_files"
    echo "2- rename_files"
    echo "3- smart_unzip"
    echo "4- smart_zip"
    echo "5- wrap_files"
    echo "6- wrap_files_in_groups"
    echo "7- Uninstall all of them"
    echo "0- Back"
    read -p "Select option:" uninstall_scripts
    case $uninstall_scripts in
		  "1") script_path="$path/extract_directory_files/script" ;;
		  "2") script_path="$path/rename_files/script" ;;
		  "3") script_path="$path/smart_unzip/script" ;;
		  "4") script_path="$path/smart_zip/script" ;;
		  "5") script_path="$path/wrap_files/script" ;;
		  "6") script_path="$path/wrap_files_in_groups/script" ;;
		  "7") scripts=("extract_directory_files"
		                "rename_files"
		                "smart_unzip"
		                "smart_zip"
		                "wrap_files"
		                "wrap_files_in_groups") ;;
		  "0") continue ;;
		  *) clear; echo -n "Invalid option: Press enter to continue"; read; continue ;;
    esac

    if [[ $uninstall_scripts == "7" ]]; then
    	clear
    	
      for script in "${scripts[@]}"; do          
      	cd "$path/$script/script"
      	bash uninstall.sh 
      done
	    
    else
	    clear
	    cd "$script_path"
	    bash uninstall.sh
    fi

    echo -n "Press enter to continue."
    read 
    clear
  elif [[ $option == 3 ]]; then
  	clear
  	scripts=("extract_directory_files"
  	         "rename_files"
  	         "smart_unzip"
  	         "smart_zip"
  	         "wrap_files"
  	         "wrap_files_in_groups")
  	         
  	for script in "${scripts[@]}"; do          
      cd "$path/$script/script"
      
      SCRIPT_NAME="$script.sh"      
			COMMAND_NAME="$script"  
			INSTALL_DIR="/usr/local/bin"
			
			if [ ! -f "$SCRIPT_NAME" ]; then
				echo "The script $SCRIPT_NAME is not found in the current directory. Please check."
				exit 1
			fi
			
			exec=$($COMMAND_NAME 2>&1)
			exit_code=$?

			if [ $exit_code == 1 ]; then
				sudo rm "$INSTALL_DIR/$COMMAND_NAME"
				sed -i "\|$INSTALL_DIR|d" ~/.bashrc
				source ~/.bashrc
			fi
			
			sudo cp "$SCRIPT_NAME" "$INSTALL_DIR/$COMMAND_NAME"
			sudo chmod +x "$INSTALL_DIR/$COMMAND_NAME"
			echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
			source ~/.bashrc
			
    done
    
		echo "~~~~~~~~~~~~~~~~~~~~~~~~"
		echo "Reinstallation completed"
		echo "~~~~~~~~~~~~~~~~~~~~~~~~" 
		
		echo -n "Press enter to continue."
    read 
    clear
		
  elif [[ $option == 0 ]]; then
  	exit 0
  else
  	clear
	  echo -n "Invalid Option: Press enter to continue."
    read
  fi
done


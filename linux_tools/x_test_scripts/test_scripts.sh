#!/bin/bash

path=$(pwd)

while true; do
	clear
  cd "$path"
  echo "1- Test script"
  echo "2- Regenerate test directories"
  echo "0- Exit"
  read -p "Select option:" option
  scripts=("extract_directory_files"
		       "rename_files"
		       "smart_unzip"
		       "smart_zip"
		       "wrap_files"
		       "wrap_files_in_groups")
  if [[ $option == 1 ]]; then
  	clear
  	echo "[test scripts]"
    echo "1- extract_directory_files"
    echo "2- rename_files"
    echo "3- smart_unzip"
    echo "4- smart_zip"
    echo "5- wrap_files"
    echo "6- wrap_files_in_groups"
    echo "7- test all scripts"
    echo "0- Back"
    read -p "Select option:" test_scripts
  	
    if [[ $test_scripts -gt 0 ]] && [[ $test_scripts -lt 7 ]]; then
			script=${scripts[$((test_scripts-1))]}         
			exec=$($script 2>&1)
			exit_code=$?
			if [[ $exit_code != 1 ]]; then
				echo "The script '$script' is not installed."
				read -p "Do you want to install it? (y/n): " answer
				case $answer in
    			"y" | "Y")
    				clear
    				cd "$path/../$script/script"
				    bash install.sh
				    echo "Try the test again"
				    echo "Press enter to continue"
				    read
				    ;;              	
    			"n" | "N")
        		continue
        		;;
    			*)
        		clear
        		echo -n "Invalid option: Press enter to continue"
        		read
        		continue
        		;;
				esac
			else
				if [[ -d "$path/result$test_scripts" ]]; then
					 clear
				   echo "Test $test_scripts was already done."
				   echo "Try another test not run yet or regenerate test directories."
				   echo -n "Press enter to continue"
        	 read
        	 continue
				fi
					
				if [[ $test_scripts == 1 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 1 +++++++++++++++++++++++++++++++"
					$script "$path/test_$script" -sk merge
					mv "$path/test_$script" "$path/result1"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
				elif [[ $test_scripts == 2 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 2 +++++++++++++++++++++++++++++++"
					$script "$path/test_$script" -sk template_name
					mv "$path/test_$script" "$path/result2"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
				elif [[ $test_scripts == 3 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 3 +++++++++++++++++++++++++++++++"
					$script "$path/test_$script" -sk merge
					mv "$path/test_$script" "$path/result3"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
				elif [[ $test_scripts == 4 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 4 +++++++++++++++++++++++++++++++"
					$script "$path/test_$script" -sk merge
					mv "$path/test_$script" "$path/result4"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
				elif [[ $test_scripts == 5 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 5 +++++++++++++++++++++++++++++++"
					$script "$path/test_$script" -sk merge
					mv "$path/test_$script" "$path/result5"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
				elif [[ $test_scripts == 6 ]]; then
					clear
					echo "+++++++++++++++++++++++++++++++ TEST 6 +++++++++++++++++++++++++++++++"
					echo "------------------------------ OPTION 1 ------------------------------"
					$script "$path/test_$script/option1" -sk1 template_name 1-2 3-4 5-7
					echo "------------------------------ OPTION 2 ------------------------------"
					$script "$path/test_$script/option2" -sk2 group_A group_B group_C 1-2 3-4 5-7
					mv "$path/test_$script" "$path/result6"
					echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"					
				fi
        echo -n "Press enter to continue"
        read
			fi
    elif [[ $test_scripts == 7 ]]; then
		    passed=0
		    for i in {1..6}; do						
						clear
						if [[ -d "$path/result$i" ]]; then
							echo "Test $i was already done."
							echo "To run all the tests, you must regenerate the test directories."
							break
						else
							script=${scripts[$((i-1))]}         
							exec=$($script 2>&1)
							exit_code=$?
							if [[ $exit_code != 1 ]]; then
								echo "The script '$script' is not installed."
								read -p "Do you want to install it? (y/n): " answer
								clear
								case $answer in
									"y" | "Y")
										cd "$path/../$script/script"
										bash install.sh
										echo "Press enter to continue"
										read
										;;    	          	
									"n" | "N")
										continue
										;;
									*)
										echo -n "Invalid option: Press enter to continue"
										read
										continue
										;;
								esac
							else
								passed=$((passed+1))
							fi		
						fi
					done
					
					if [[ $passed == 6 ]]; then
						clear
						echo "+++++++++++++++++++++++++++++++ TEST 1 +++++++++++++++++++++++++++++++"
						script=${scripts[0]}
						$script "$path/test_$script" -sk merge
						mv "$path/test_$script" "$path/result1"
						echo "+++++++++++++++++++++++++++++++ TEST 2 +++++++++++++++++++++++++++++++"
						script=${scripts[1]}
						$script "$path/test_$script" -sk template_name
						mv "$path/test_$script" "$path/result2"
						echo "+++++++++++++++++++++++++++++++ TEST 3 +++++++++++++++++++++++++++++++"
						script=${scripts[2]}
						$script "$path/test_$script" -sk merge
						mv "$path/test_$script" "$path/result3"	
						echo "+++++++++++++++++++++++++++++++ TEST 4 +++++++++++++++++++++++++++++++"
						script=${scripts[3]}
						$script "$path/test_$script" -sk merge
						mv "$path/test_$script" "$path/result4"
						echo "+++++++++++++++++++++++++++++++ TEST 5 +++++++++++++++++++++++++++++++"
						script=${scripts[4]}
						$script "$path/test_$script" -sk merge
						mv "$path/test_$script" "$path/result5"
						echo "+++++++++++++++++++++++++++++++ TEST 6 +++++++++++++++++++++++++++++++"
						script=${scripts[5]}
						echo "------------------------------ OPTION 1 ------------------------------"
						$script "$path/test_$script/option1" -sk1 template_name 1-2 3-4 5-7
						echo "------------------------------ OPTION 2 ------------------------------"
						$script "$path/test_$script/option2" -sk2 group_A group_B group_C 1-2 3-4 5-7
						mv "$path/test_$script" "$path/result6"
						echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
						echo
						else
							echo "Try the tests again"
					fi
					
					echo -n "Press enter to continue"
					read
					continue
						
    elif [[ $test_scripts == 0 ]]; then
    	continue
    else
    	clear; echo -n "Invalid option: Press enter to continue"; read; continue
		fi
  elif [[ $option == 2 ]]; then
    clear
    directories=$(ls "$path" | grep -v "test_scripts.sh")  
    for dir in $directories; do
			rm -r "$path/$dir"
		done
		for script in "${scripts[@]}"; do
			cp -r "$path/../$script/script/test_$script/" "$path"
			echo "----------------------------------------------------------------"
			echo "Directory with the tests for $script regenerated"
			echo "----------------------------------------------------------------"		     
		done
		echo -n "Press enter to continue."
    read   
  elif [[ $option == 0 ]]; then
  	exit 0
  else
  	clear
	  echo -n "Invalid Option: Press enter to continue."
    read
  fi
done




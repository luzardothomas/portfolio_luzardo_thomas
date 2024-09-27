#!/bin/bash

COMMAND_NAME="wrap_files"
INSTALL_DIR="/usr/local/bin"

exec=$($COMMAND_NAME 2>&1)
exit_code=$?

if [ $exit_code == 1 ]; then
	sudo rm "$INSTALL_DIR/$COMMAND_NAME"
	echo "The command '$COMMAND_NAME' has been removed from $INSTALL_DIR."
	sed -i "\|$INSTALL_DIR|d" ~/.bashrc
	echo "The directory $INSTALL_DIR has been removed from the PATH in .bashrc."
	source ~/.bashrc
	echo "~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Uninstallation complete"
	echo "~~~~~~~~~~~~~~~~~~~~~~~"
else
	echo "********************************************************"
	echo "The command '$COMMAND_NAME' was not installed."
	echo "********************************************************"
fi










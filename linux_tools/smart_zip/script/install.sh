#!/bin/bash

SCRIPT_NAME="smart_zip.sh"
COMMAND_NAME="smart_zip"
INSTALL_DIR="/usr/local/bin"

if [ ! -f "$SCRIPT_NAME" ]; then
	echo "The script $SCRIPT_NAME is not found in the current directory. Please check."
	exit 1
fi

exec=$($COMMAND_NAME 2>&1)
exit_code=$?

if [[ $exit_code == 1 ]]; then
	echo "*******************************************************"
	echo "The command '$COMMAND_NAME' is already installed."
	echo "*******************************************************"
else
	sudo cp "$SCRIPT_NAME" "$INSTALL_DIR/$COMMAND_NAME"
	echo "The command '$COMMAND_NAME' has been installed in $INSTALL_DIR."
	sudo chmod +x "$INSTALL_DIR/$COMMAND_NAME"
	echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
	echo "The directory $INSTALL_DIR has been added to your PATH in .bashrc."
	source ~/.bashrc
	echo "~~~~~~~~~~~~~~~~~~~~~~"
	echo "Installation completed"
	echo "~~~~~~~~~~~~~~~~~~~~~~"
fi


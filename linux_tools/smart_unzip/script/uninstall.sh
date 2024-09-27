#!/bin/bash

# Configura el nombre del comando y el directorio de instalación
COMMAND_NAME="smart_unzip"
INSTALL_DIR="/usr/local/bin"

exec=$($COMMAND_NAME 2>&1)
exit_code=$?

if [ $exit_code == 1 ]; then
	sudo rm "$INSTALL_DIR/$COMMAND_NAME"
	echo "El comando '$COMMAND_NAME' ha sido eliminado de $INSTALL_DIR."
	sed -i "\|$INSTALL_DIR|d" ~/.bashrc
	echo "El directorio $INSTALL_DIR ha sido eliminado del PATH en .bashrc."
	source ~/.bashrc
	echo "~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Desinstalación completa"
	echo "~~~~~~~~~~~~~~~~~~~~~~~"
else
	echo "*********************************************************"
	echo "El comando '$COMMAND_NAME' no estaba instalado."
	echo "*********************************************************"
fi









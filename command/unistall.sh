#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
STORAGE_DIR=$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2))

echo "[ UNISTALL ]"
sudo rm -rf '/usr/local/bin/psk'
sudo rm -rf $PSK_DIR
read -e -p "do you want to delete the storage folder? (y/N): " INPUT
if [ "$INPUT" = "y" ]; then
	read -e -p "Are you sure ? because this will delete all related data. (y/N): " INPUT
	if [  "$INPUT" = "y" ]; then
		sudo rm -rf $STORAGE_DIR
	fi
fi

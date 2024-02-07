#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
ENV_PATH="$CONFIG_DIR/psk/.env"
STORAGE=$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2)

COMPLETE="$STORAGE/downloads/complete"
INCOMPLETE="$STORAGE/downloads/incomplete"

del_files(){
	DIRECTORY=$1
	find "$DIRECTORY" -type f -mtime +5 -exec rm {} \;
	echo "Files older than 5 days in $DIRECTORY have been deleted."
}

del_files $COMPLETE
del_files $INCOMPLETE
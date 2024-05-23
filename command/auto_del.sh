#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
ENV_PATH="$CONFIG_DIR/psk/.env"
STORAGE=$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2))

COMPLETE="$STORAGE/downloads/complete"
INCOMPLETE="$STORAGE/downloads/incomplete"
LOG_FILE="$CONFIG_DIR/logs/deletion.log"

del_files(){
	DIRECTORY=$1
	if [ -d "$DIRECTORY" ]; then
		find "$DIRECTORY" -type f -mtime +5 -print -exec rm {} \; | while read FILE; do
			echo "$(date '+%Y-%m-%d %H:%M:%S') - Deleted: $FILE" >> "$LOG_FILE"
		done
		echo "Files older than 5 days in $DIRECTORY have been deleted."
	else
		echo "$(date '+%Y-%m-%d %H:%M:%S') - Directory $DIRECTORY does not exist. No files were deleted." >> "$LOG_FILE"
		echo "Directory $DIRECTORY does not exist. No files were deleted."
	fi
}

del_files $COMPLETE
del_files $INCOMPLETE
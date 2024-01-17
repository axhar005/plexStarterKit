#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
ENV_PATH="$CONFIG_DIR/psk/.env"
COMMAND_DIR="$PSK_DIR/command"

if [ "$1" = "env" ]; then
	cat $ENV_PATH
elif [ "$1" = "storage" ]; then
	echo "$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2))"
else
	cat "$PSK_DIR/.help"
fi
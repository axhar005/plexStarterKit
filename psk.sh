#!/bin/bash

#files variable
CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR=$CONFIG_DIR/psk
COMMAND_DIR="$PSK_DIR/command"
STORAGE_DIR=$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2))
VPN_USER=$(eval echo $(grep 'VPN_USER=' $PSK_DIR/.env | cut -d '=' -f2))
VPN_PASS=$(eval echo $(grep 'VPN_PASS=' $PSK_DIR/.env | cut -d '=' -f2))
PLEX_CLAIM=$(eval echo $(grep 'PLEX_CLAIM=' $PSK_DIR/.env | cut -d '=' -f2))
PLEX_IP=$(eval echo $(grep 'PLEX_IP=' $PSK_DIR/.env | cut -d '=' -f2))

#main
# HELP
if [ "$1" = "help" ] || [ "$1" = "-help" ] || [ "$1" = "-h" ]; then
	echo "> psk execute $1"
	cat .header
	cat $PSK_DIR/.help

# START
elif [ "$1" = "run" ] || [ "$1" = "up" ] || [ "$1" = "-r" ]; then
	echo "> psk execute $1"
	docker compose -f $PSK_DIR/docker-compose.yml up -d

# STOP
elif [ "$1" = "stop" ] || [ "$1" = "down" ] || [ "$1" = "-s" ]; then
	echo "> psk execute $1"
	docker compose -f $PSK_DIR/docker-compose.yml down

# RESTART
elif [ "$1" = "restart" ]; then
	echo "> psk execute $1"
	docker compose -f $PSK_DIR/docker-compose.yml down && docker compose -f $PSK_DIR/docker-compose.yml up -d

# ENV
elif [ "$1" = "env" ]; then
	echo "> psk execute env"
	bash $COMMAND_DIR/env.sh setup

# STORAGE
elif [ "$1" = "storage" ]; then
	echo "> psk execute storage"
	bash "$COMMAND_DIR/storage.sh"

# VPN
elif [ "$1" = "vpn" ]; then
	bash "$COMMAND_DIR/env.sh vpn"

# SHOW
elif [ "$1" = "show" ] || [ "$1" = "-s" ]; then
	echo "> psk execute $1"
	if [ "$2" = "" ]; then
		cat $PSK_DIR/.help
	else
		bash "$COMMAND_DIR/show.sh" "$2"
	fi

# EDIT
elif [ "$1" = "edit" ] || [ "$1" = "-e" ]; then
	echo "> psk execute $1"
	if [ "$2" = "env" ]; then
		nano -m $PSK_DIR/.env
	fi

# STATUS
elif [ "$1" = "status" ] || [ "$1" = "ps" ]; then
	echo "> psk execute $1"
	docker ps

# UPDATE
elif [ "$1" = "update" ]; then
	echo "> psk execute $1"
	(cd "$PSK_DIR" && git config --global --add safe.directory "$PSK_DIR" && git pull)
	bash $COMMAND_DIR/update_psk.sh

#UNISTALL
elif [ "$1" = "unistall" ]; then
	echo "> psk execute $1"
	bash $COMMAND_DIR/unistall.sh

else
	cat .header
	cat $PSK_DIR/.help
fi
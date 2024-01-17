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
if [ "$1" = "-help" ] || [ "$1" = "help" ]; then
	cat $PSK_DIR/.help

# START
elif [ "$1" = "start" ]; then
	echo "psk: start"
	docker compose -f $PSK_DIR/docker-compose.yml up -d

# STOP
elif [ "$1" = "stop" ]; then
	echo "psk: stop"
	docker compose -f $PSK_DIR/docker-compose.yml down

# RESTART
elif [ "$1" = "restart" ]; then
	echo "psk: restart"
	docker compose -f $PSK_DIR/docker-compose.yml down && docker compose -f $PSK_DIR/docker-compose.yml up -d

# ENV
elif [ "$1" = "env" ]; then
	bash $COMMAND_DIR/env.sh setup

# STORAGE
elif [ "$1" = "init-storage" ]; then
	bash "$COMMAND_DIR/storage.sh"

# VPN
elif [ "$1" = "init-vpn" ]; then
	bash "$COMMAND_DIR/env.sh vpn"

# STATUS
elif [ "$1" = "status" ]; then
	docker ps

# UPDATE
elif [ "$1" = "update" ]; then
	git pull

#UNISTALL
elif [ "$1" = "unistall" ]; then
	bash $COMMAND_DIR/unistall.sh

else
	echo "unknow commande $1"
fi

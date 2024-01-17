#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
ENV_PATH="$CONFIG_DIR/psk/.env"
TEMPFILE="$HOME/temp_vpn"
GLUETUN="$CONFIG_DIR/gluetun"
STORAGE_DIR=$(eval echo $(grep 'STORAGE_DIR=' $PSK_DIR/.env | cut -d '=' -f2))

if [ ! -z "$STORAGE_DIR" ]; then
	sudo mkdir -p "$STORAGE_DIR"
	sudo chown -R $USER:$USER "${STORAGE_DIR}"
	sudo chmod -R a=,a+rX,u+w,g+w "${STORAGE_DIR}"
	mkdir -p "$STORAGE_DIR/downloads"
	mkdir -p "$STORAGE_DIR/downloads/complete"
	mkdir -p "$STORAGE_DIR/downloads/incomplete"
	mkdir -p "$STORAGE_DIR/media"
	mkdir -p "$STORAGE_DIR/media/animes"
	mkdir -p "$STORAGE_DIR/media/movies"
	mkdir -p "$STORAGE_DIR/media/series"
fi
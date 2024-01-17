#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
ENV_PATH="$CONFIG_DIR/psk/.env"
TEMPFILE="$HOME/temp_vpn"
GLUETUN="$CONFIG_DIR/gluetun"

create_env_file(){
	touch $ENV_PATH
	echo "# Global Settings" >> "$ENV_PATH"
	echo "CONFIG_DIR='$HOME/.config/appdata'" >> "$ENV_PATH"
	echo "STORAGE_DIR='/data'" >> "$ENV_PATH"
	echo "PGID='1000'" >> "$ENV_PATH"
	echo "PUID='1000'" >> "$ENV_PATH"
	echo "TZ='America/Chicago'" >> "$ENV_PATH"
	echo "" >> "$ENV_PATH"
	echo "# PLEX" >> "$ENV_PATH"
	echo "PLEX_IP='http://your_ip_local:your_port/'" >> "$ENV_PATH"
	echo "PLEX_CLAIM='your_plex_claim_www.plex/claim'" >> "$ENV_PATH"
	echo "" >> "$ENV_PATH"
	echo "# VPN Settings" >> "$ENV_PATH"
	echo "LAN_NETWORK='192.168.0.1/24'" >> "$ENV_PATH"
	echo "NS1='1.1.1.1'" >> "$ENV_PATH"
	echo "NS2='8.8.8.8'" >> "$ENV_PATH"
	echo "VPN_CLIENT='your_provider'" >> "$ENV_PATH"
	echo "VPN_USER='your_username'" >> "$ENV_PATH"
	echo "VPN_PASS='your_password'" >> "$ENV_PATH"
	echo "VPN_TZ='your_timezone(America/Chicago)'" >> "$ENV_PATH"
	echo "" >> "$ENV_PATH"
	echo "# END OF DEFAULT SETTINGS" >> "$ENV_PATH"
	echo "RESTART='always'" >> "$ENV_PATH"
}

env(){
if [ ! -f "$ENV_PATH" ]; then
	create_env_file
else
	read -e -p ".env alrady exist, erase ? (y/n): " INPUT
	if [ "$INPUT" = "y" ]; then
		rm -rf $ENV_PATH
		create_env_file
	fi
fi
}

vpn(){
	echo "[ VPN SETUP ]"
	read -e -p "VPN PROVIDER: " PROVIDER
	read -e -p "VPN USERNAME: " USERNAME
	read -e -p "VPN PASSWORD: " PASSWORD
	read -e -p "VPN TIMEZONE: " TIMEZONE
	mkdir -p $TEMPFILE
	echo "place the client.crt and client.key files from your VPN into this temporary folder. '$TEMPFILE'"
	read -p "Press Enter to continue... "
	if [ -n "$(ls -A /home/psk/temp_vpn/ 2>/dev/null)" ]; then
		cp "$TEMPFILE/"* "$GLUETUN"
	else
		echo "No such files in '$TEMPFILE'"
	fi
	rm -rf "$TEMPFILE"

	sed -i 's|VPN_CLIENT=.*|VPN_CLIENT='"'$PROVIDER'"'|' $PSK_DIR/.env
	sed -i 's|VPN_USER=.*|VPN_USER='"'$USERNAME'"'|' $PSK_DIR/.env
	sed -i 's|VPN_PASS=.*|VPN_PASS='"'$PASSWORD'"'|' $PSK_DIR/.env
	sed -i 's|VPN_TZ=.*|VPN_TZ='"'$TIMEZONE'"'|' $PSK_DIR/.env
}

plex(){
	echo "[ PLEX SETUP ]"
	read -e -p "PLEX IP: " PLEX_IP
	read -e -p "PLEX CLAIM (https://www.plex.tv/claim/): " PLEX_CLAIM
	sed -i 's|VPN_CLIENT=.*|VPN_CLIENT='"'$PROVIDER'"'|' $PSK_DIR/.env
	sed -i 's|VPN_CLIENT=.*|VPN_CLIENT='"'$PROVIDER'"'|' $PSK_DIR/.env
}

storage(){
	echo "[ STORAGE SETUP ]"
	read -e -p "STORAGE DIR: " STORAGE_DIR
	sed -i 's|STORAGE_DIR=.*|STORAGE_DIR='"'$STORAGE_DIR'"'|' $PSK_DIR/.env
}

if [ "$1" = "env" ]; then
	env
elif [ "$1" = "vpn" ]; then
	vpn
elif [ "$1" = "plex" ]; then
	plex
elif [ "$1" = "storage" ]; then
	storage
elif [ "$1" = "setup" ]; then
	env
	storage
	vpn
	plex
fi


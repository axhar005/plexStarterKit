#!/bin/bash

#files variable
DOCKERCONFDIR="$HOME/.config/appdata"
PSK_DIR=$DOCKERCONFDIR/psk
SONARR_DIR=$DOCKERCONFDIR/sonarr
RADARR_DIR=$DOCKERCONFDIR/radarr
PROWLARR_DIR=$DOCKERCONFDIR/prowlarr
OVERSEERR_DIR=$DOCKERCONFDIR/overseerr
DOCKERSTORAGEDIR=$(eval echo $(grep 'DOCKERSTORAGEDIR=' $PSK_DIR/.env | cut -d '=' -f2))
VPN_USER=$(eval echo $(grep 'VPN_USER=' $PSK_DIR/.env | cut -d '=' -f2))
VPN_PASS=$(eval echo $(grep 'VPN_PASS=' $PSK_DIR/.env | cut -d '=' -f2))
PLEX_CLAIM=$(eval echo $(grep 'PLEX_CLAIM=' $PSK_DIR/.env | cut -d '=' -f2))
PLEX_IP=$(eval echo $(grep 'PLEX_IP=' $PSK_DIR/.env | cut -d '=' -f2))

#main
if [ "$1" = "-help" ] || [ "$1" = "help" ]; then
	cat $PSK_DIR/.help
elif [ "$1" = "start" ]; then
	echo "psk: start"
	docker compose -f $PSK_DIR up -d
elif [ "$1" = "stop" ]; then
	echo "psk: stop"
	docker compose -f $PSK_DIR down
elif [ "$1" = "restart" ]; then
	echo "psk: restart"
	docker compose -f $PSK_DIR down && docker compose -f $PSK_DIR up -d
elif [ "$1" = "env" ]; then
	# read -e -p "Docker configuration directory (default: $HOME/.config/appdata): " DOCKERCONFDIR
	# DOCKERCONFDIR="$HOME/.config/appdata"

	read -e -p "Storage directory (default: /data): " DOCKERSTORAGEDIR
	DOCKERSTORAGEDIR=${DOCKERSTORAGEDIR:-/data}

	read -e -p "Username for VPN (default: your_vpn_username): " VPN_USER
	VPN_USER=${VPN_USER:-your_vpn_username}

	read -e -p "Password for VPN (default: your_vpn_password): " VPN_PASS
	VPN_PASS=${VPN_PASS:-your_vpn_password}

	read -e -p "Plex claim (default: your_claim'https://www.plex.tv/claim/'): " PLEX_CLAIM
	PLEX_CLAIM=${PLEX_CLAIM:-your_claim}

	read -e -p "PLEX IP (default: http://192.168.0.120:32400/): " PLEX_IP
	PLEX_IP=${PLEX_IP:-http://192.168.0.120:32400/}

	sed -i 's|DOCKERSTORAGEDIR=.*|DOCKERSTORAGEDIR='"'$DOCKERSTORAGEDIR'"'|' $PSK_DIR/.env
	sed -i 's|VPN_USER=.*|VPN_USER='"'$VPN_USER'"'|' $PSK_DIR/.env
	sed -i 's|VPN_PASS=.*|VPN_PASS='"'$VPN_PASS'"'|' $PSK_DIR/.env
	sed -i 's|DOCKERCONFDIR=.*|DOCKERCONFDIR='"'$DOCKERCONFDIR'"'|' $PSK_DIR/.env
	sed -i 's|PLEX_CLAIM=.*|PLEX_CLAIM='"'$PLEX_CLAIM'"'|' $PSK_DIR/.env
	sed -i 's|PLEX_IP=.*|PLEX_IP='"'$PLEX_IP'"'|' $PSK_DIR/.env

elif [ "$1" = "init-storage" ]; then
	if [ -z "$DOCKERCONFDIR" ] || [ -z "$DOCKERSTORAGEDIR" ] || [ -z "$VPN_USER" ] || [ -z "$VPN_PASS" ] || [ -z "$PLEX_CLAIM" ] || [ -z "$PLEX_IP" ]; then
		echo "psk: env variables missing"
		exit 1
	fi

	if [ ! -z "$DOCKERSTORAGEDIR" ]; then
		sudo mkdir -p "$DOCKERSTORAGEDIR"
		sudo chown -R $USER:$USER "${DOCKERSTORAGEDIR}"
		sudo chmod -R a=,a+rX,u+w,g+w "${DOCKERSTORAGEDIR}"
		mkdir -p "$DOCKERSTORAGEDIR/downloads"
		mkdir -p "$DOCKERSTORAGEDIR/downloads/complete"
		mkdir -p "$DOCKERSTORAGEDIR/downloads/incomplete"
		mkdir -p "$DOCKERSTORAGEDIR/media"
		mkdir -p "$DOCKERSTORAGEDIR/media/animes"
		mkdir -p "$DOCKERSTORAGEDIR/media/movies"
		mkdir -p "$DOCKERSTORAGEDIR/media/series"
	fi
elif [ "$1" = "init-config" ]; then
	if [ ! -z "$DOCKERCONFDIR" ]; then
		mkdir -p "$DOCKERCONFDIR"
		mkdir -p "$DOCKERCONFDIR/psk"
		mkdir -p "$DOCKERCONFDIR/prowlarr"
		mkdir -p "$DOCKERCONFDIR/sonarr"
		mkdir -p "$DOCKERCONFDIR/radarr"
		mkdir -p "$DOCKERCONFDIR/transmission"
		mkdir -p "$DOCKERCONFDIR/plex"
		mkdir -p "$DOCKERCONFDIR/overseerr"
	fi

elif [ "$1" = "status" ]; then
	docker ps

elif [ "$1" = "update" ]; then
	git pull

elif [ "$1" = "unistall" ]; then
	sudo rm -rf '/usr/local/bin/psk'
	sudo rm -rf $PSK_DIR
else
	echo "unknow commande $1"
fi

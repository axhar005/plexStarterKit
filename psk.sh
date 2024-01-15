#!/bin/bash


#files variable
DOCKERCONFDIR="$HOME/.config/appdata"
PSKDIR=$DOCKERCONFDIR/psk
DOCKERSTORAGEDIR=$(eval echo $(grep 'DOCKERSTORAGEDIR=' $PSKDIR/.env | cut -d '=' -f2))
VPN_USER=$(eval echo $(grep 'VPN_USER=' $PSKDIR/.env | cut -d '=' -f2))
VPN_PASS=$(eval echo $(grep 'VPN_PASS=' $PSKDIR/.env | cut -d '=' -f2))
PLEX_CLAIM=$(eval echo $(grep 'PLEX_CLAIM=' $PSKDIR/.env | cut -d '=' -f2))
PLEX_IP=$(eval echo $(grep 'PLEX_IP=' $PSKDIR/.env | cut -d '=' -f2))

#main
if [ "$1" = "-help" ] || [ "$1" = "help" ]; then
	echo "help $PSKDIR"
	echo ${DOCKERSTORAGEDIR}
	echo $VPN_USER
elif [ "$1" = "start" ]; then
	echo "plexStarterKit start"
	docker compose -f $PSKDIR up -d
elif [ "$1" = "stop" ]; then
	echo "plexStarterKit stop"
	docker compose -f $PSKDIR down
elif [ "$1" = "restart" ]; then
	echo "plexStarterKit restart"
	docker compose -f $PSKDIR down && docker compose -f $PSKDIR up -d
elif [ "$1" = "env" ]; then
	# read -e -p "Docker configuration directory (default: $HOME/.config/appdata): " DOCKERCONFDIR
	# DOCKERCONFDIR="$HOME/.config/appdata"

	read -e -p "Storage directory (default: /data): " DOCKERSTORAGEDIR
	DOCKERSTORAGEDIR=${DOCKERSTORAGEDIR:-/data}

	read -p "Username for VPN (default: your_vpn_username): " VPN_USER
	VPN_USER=${VPN_USER:-your_vpn_username}

	read -p "Password for VPN (default: your_vpn_password): " VPN_PASS
	VPN_PASS=${VPN_PASS:-your_vpn_password}

	read -p "Plex claim (default: your_claim'https://www.plex.tv/claim/'): " PLEX_CLAIM
	PLEX_CLAIM=${PLEX_CLAIM:-your_claim}

	read -p "PLEX IP (default: http://192.168.0.120:32400/): " PLEX_IP
	PLEX_IP=${PLEX_IP:-http://192.168.0.120:32400/}

	sed -i 's|DOCKERSTORAGEDIR=.*|DOCKERSTORAGEDIR='"'$DOCKERSTORAGEDIR'"'|' .env
	sed -i 's|VPN_USER=.*|VPN_USER='"'$VPN_USER'"'|' .env
	sed -i 's|VPN_PASS=.*|VPN_PASS='"'$VPN_PASS'"'|' .env
	sed -i 's|DOCKERCONFDIR=.*|DOCKERCONFDIR='"'$DOCKERCONFDIR'"'|' .env
	sed -i 's|PLEX_CLAIM=.*|PLEX_CLAIM='"'$PLEX_CLAIM'"'|' .env
	sed -i 's|PLEX_IP=.*|PLEX_IP='"'$PLEX_IP'"'|' .env

elif [ "$1" = "files" ]; then
	if [ -z "$DOCKERCONFDIR" ] || [ -z "$DOCKERSTORAGEDIR" ] || [ -z "$VPN_USER" ] || [ -z "$VPN_PASS" ] || [ -z "$PLEX_CLAIM" ] || [ -z "$PLEX_IP" ]; then
		echo "env variables missing"
		exit 1
	fi

	if [ ! -z "$DOCKERSTORAGEDIR" ]; then
		mkdir -p "${DOCKERSTORAGEDIR}"
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
elif [ "$1" = "configfiles" ]; then
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
elif [ "$1" = "unistall" ]; then
	sudo rm -rf '/usr/local/bin/psk'
	sudo rm -rf $PSKDIR
	# sudo rm -rf $DOCKERSTORAGEDIR/*
else
	echo "unknow commande $1"
fi

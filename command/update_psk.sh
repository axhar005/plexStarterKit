#!/bin/bash

CONFIG_DIR="$HOME/.config/appdata"
LOG_FILE="$CONFIG_DIR/logs/psk.log"
TARGET="/usr/local/bin/psk"

# Créer le répertoire de logs s'il n'existe pas
mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Vérifier si le fichier cible existe
if [ -f "$TARGET" ]; then
	sudo cp ../psk.sh "$TARGET"
	log_message "File replaced at $TARGET"
	echo "File has been replaced at $TARGET"
else
	sudo cp ../psk.sh "$TARGET"
	log_message "File created at $TARGET"
	echo "File has been created at $TARGET"
fi

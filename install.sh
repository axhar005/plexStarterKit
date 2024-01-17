#!/bin/bash

# variables
CONFIG_DIR="$HOME/.config/appdata"
PSK_DIR="$CONFIG_DIR/psk"
COMMAND_DIR="$PSK_DIR/command"

# show the headers
header() {
	cat .header
}

# dependencies
dependencies() {
	read -p "install dependencies ? (y/n): " DOINSTALL
	if [ "$DOINSTALL" != "y" ]; then
		echo "the dependencies will not be installed"
	else
		sudo apt update
		sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
		sudo apt-get update
		sudo apt-get install docker-ce
		sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
		docker-compose --version
		sudo usermod -aG docker $USER
		newgrp docker
	fi
}

# setup 
setup() {
	mkdir -p $CONFIG_DIR
	mkdir -p $CONFIG_DIR/psk
	echo "give permissions to the 'psk' command"
	sudo chmod +x psk.sh
	sudo cp -r . $CONFIG_DIR/psk
	sudo cp psk.sh /usr/local/bin/psk
	echo "'psk' command setup complete, and folder copied to the config folder"
}

# env
env() {
	bash $COMMAND_DIR/env.sh setup
}

# folder
storage() {
	bash "$COMMAND_DIR/storage.sh"
}

# main
header
dependencies
setup
env
storage

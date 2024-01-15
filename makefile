#files variable
DOCKERCONFDIR="$(HOME)/.config/appdata"

all:
	@cat .header

dependencies:
	@sudo apt update
	@sudo chmod +x psk.sh
	@sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	@sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	@sudo apt-get update
	@sudo apt-get install docker-ce
	@sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	@sudo chmod +x /usr/local/bin/docker-compose
	@docker-compose --version
	@sudo usermod -aG docker $(USER)
	@newgrp docker

setup:
	@mkdir -p $(DOCKERCONFDIR)
	@mkdir -p $(DOCKERCONFDIR)/psk
	@sudo cp -r . $(DOCKERCONFDIR)/psk
	@sudo cp psk.sh /usr/local/bin/psk

env:
	bash psk env

files:


.PHONY: all

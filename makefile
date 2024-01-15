#files variable
DOCKERCONFDIR="$(HOME)/.config/appdata"

all:
	@sh install.sh

header:
	@cat .header

dependencies: check-install
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

check-install:
	@read -p "Storage directory (y / n): " DOINSTALL; \
	if [ "$$DOINSTALL" != "y" ]; then \
		echo "psk: the answer is not y, abort"; \
		exit 1; \
	fi;

setup:
	@mkdir -p $(DOCKERCONFDIR)
	@mkdir -p $(DOCKERCONFDIR)/psk
	@sudo cp -r . $(DOCKERCONFDIR)/psk
	@sudo cp psk.sh /usr/local/bin/psk

env:
	@psk env

files:
	@psk env


.PHONY: all

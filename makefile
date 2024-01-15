#files variable
DOCKERCONFDIR="$(HOME)/.config/appdata"

all: dependencies env

dependencies:
	@sudo apt update
	@sudo chmod +x psk.sh
	@sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	@sudo chmod +x /usr/local/bin/docker-compose
	@docker-compose --version

setup:
	mkdir -p $(DOCKERCONFDIR)
	mkdir -p $(DOCKERCONFDIR)/psk
	@sudo cp -r . $(DOCKERCONFDIR)/psk
	@sudo cp psk.sh /usr/local/bin/psk

env:
	bash psk env

files:


.PHONY: all

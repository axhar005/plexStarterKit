#files variable
DOCKERCONFDIR=
DOCKERSTORAGEDIR=
VPN_USER=
VPN_PASS=
PLEX_CLAIM=
PLEX_IP=


all: env files

dependencies:
	@sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	@sudo chmod +x /usr/local/bin/docker-compose
	@docker-compose --version

env:
	@read -p "Docker configuration directory (default: $$HOME/.config/appdata): " DOCKERCONFDIR; DOCKERCONFDIR=$${DOCKERCONFDIR:-$$HOME/.config/appdata}; \
	read -p "Storage directory (default: /data): " DOCKERSTORAGEDIR; DOCKERSTORAGEDIR=$${DOCKERSTORAGEDIR:-/data}; \
	read -p "Username for VPN (default: your_vpn_username): " VPN_USER; VPN_USER=$${VPN_USER:-your_vpn_username}; \
	read -p "Password for VPN (default: your_vpn_password): " VPN_PASS; VPN_PASS=$${VPN_PASS:-your_vpn_password}; \
	read -p "Plex claim (default: your_claim'https://www.plex.tv/claim/'): " PLEX_CLAIM; PLEX_CLAIM=$${PLEX_CLAIM:-your_claim}; \
	read -p "PLEX IP (default: http://192.168.0.120:32400/): " PLEX_IP; PLEX_IP=$${PLEX_IP:-http://192.168.0.0:32400/}; \
	if [ $$(uname) = Darwin ]; then \
		sed -i '' 's|DOCKERSTORAGEDIR=.*|DOCKERSTORAGEDIR='"'$$DOCKERSTORAGEDIR'"'|' .env; \
		sed -i '' 's|VPN_USER=.*|VPN_USER='"'$$VPN_USER'"'|' .env; \
		sed -i '' 's|VPN_PASS=.*|VPN_PASS='"'$$VPN_PASS'"'|' .env; \
		sed -i '' 's|DOCKERCONFDIR=.*|DOCKERCONFDIR='"'$$DOCKERCONFDIR'"'|' .env; \
		sed -i '' 's|PLEX_CLAIM=.*|PLEX_CLAIM='"'$$PLEX_CLAIM'"'|' .env; \
		sed -i '' 's|PLEX_IP=.*|PLEX_IP='"'$$PLEX_IP'"'|' .env; \
	else \
		sed -i 's|DOCKERSTORAGEDIR=.*|DOCKERSTORAGEDIR='"'$$STORAGE_DIR'"'|' .env; \
		sed -i 's|VPN_USER=.*|VPN_USER='"'$$VPN_USER'"'|' .env; \
		sed -i 's|VPN_PASS=.*|VPN_PASS='"'$$VPN_PASS'"'|' .env; \
		sed -i 's|DOCKERCONFDIR=.*|DOCKERCONFDIR='"'$$DOCKERCONFDIR'"'|' .env; \
		sed -i 's|PLEX_CLAIM=.*|PLEX_CLAIM='"'$$PLEX_CLAIM'"'|' .env; \
		sed -i 's|PLEX_IP=.*|PLEX_IP='"'$$PLEX_IP'"'|' .env; \
	fi;

files:
	$(eval DOCKERCONFDIR=$(shell grep 'DOCKERCONFDIR=' .env | cut -d '=' -f2))
	$(eval DOCKERSTORAGEDIR=$(shell grep 'DOCKERSTORAGEDIR=' .env | cut -d '=' -f2))
	$(eval VPN_USER=$(shell grep 'VPN_USER=' .env | cut -d '=' -f2))
	$(eval VPN_PASS=$(shell grep 'VPN_PASS=' .env | cut -d '=' -f2))
	$(eval PLEX_CLAIM=$(shell grep 'PLEX_CLAIM=' .env | cut -d '=' -f2))
	$(eval PLEX_IP=$(shell grep 'PLEX_IP=' .env | cut -d '=' -f2))

	@if [ -z "$(DOCKERCONFDIR)" ] || [ -z "$(DOCKERSTORAGEDIR)" ] || [ -z "$(VPN_USER)" ] || [ -z "$(VPN_PASS)" ] || [ -z "$(PLEX_CLAIM)" ] || [ -z "$(PLEX_IP)" ]; then \
		$(MAKE) env; \
	fi

	@if [ ! -z "$(DOCKERSTORAGEDIR)" ]; then \
		mkdir -p $(DOCKERSTORAGEDIR); \
		mkdir -p $(DOCKERSTORAGEDIR)/downloads; \
		mkdir -p $(DOCKERSTORAGEDIR)/downloads/complete; \
		mkdir -p $(DOCKERSTORAGEDIR)/downloads/incomplete; \
		mkdir -p $(DOCKERSTORAGEDIR)/media; \
		mkdir -p $(DOCKERSTORAGEDIR)/media/animes; \
		mkdir -p $(DOCKERSTORAGEDIR)/media/movies; \
		mkdir -p $(DOCKERSTORAGEDIR)/media/series; \
	fi

	@if [ ! -z "$(DOCKERCONFDIR)" ]; then \
		mkdir -p $(DOCKERCONFDIR)/appdata; \
		mkdir -p $(DOCKERCONFDIR)/appdata/prowlarr; \
		mkdir -p $(DOCKERCONFDIR)/appdata/sonarr; \
		mkdir -p $(DOCKERCONFDIR)/appdata/radarr; \
		mkdir -p $(DOCKERCONFDIR)/appdata/transmission; \
		mkdir -p $(DOCKERCONFDIR)/appdata/plex; \
		mkdir -p $(DOCKERCONFDIR)/appdata/overseerr; \
	fi

permissions:
	sudo chown -R $USER:$USER $(DOCKERSTORAGEDIR)
	sudo chmod -R a=,a+rX,u+w,g+w $(DOCKERSTORAGEDIR)



.PHONY: all

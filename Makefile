

UNAME := $(shell uname)
HOSTNAME := $(shell hostname)

home:
ifndef TARGET
	home-manager switch --flake ".#${USER}@${HOSTNAME}"
else
	home-manager switch --flake $(TARGET)
endif



switch:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nix-collect-garbage -d
	sudo nixos-rebuild switch --flake ".#" --show-trace
endif


boot:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nix-collect-garbage -d
	sudo nixos-rebuild boot --flake ".#"
endif


test:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nixos-rebuild test --flake ".#"
endif


hetzner-switch:
	nixos-rebuild switch --flake .#hetzner-cloud  --target-host root@piftel.bitsikas.dev

gmktec-switch:
	nixos-rebuild switch --flake .#gmktec-cloud  --target-host root@100.64.0.8

pi-switch:
	nixos-rebuild switch --flake .#beershot  --target-host root@100.64.0.1

asus-switch:
	nixos-rebuild switch --flake .#asus  --target-host root@100.64.0.7



hetzner-boot:
	nixos-rebuild boot --flake .#hetzner-cloud  --target-host root@piftel.bitsikas.dev

gmktec-boot:
	nixos-rebuild boot --flake .#gmktec-cloud  --target-host root@100.64.0.8

pi-boot:
	nixos-rebuild boot --flake .#beershot  --target-host root@100.64.0.1

asus-boot:
	nixos-rebuild boot --flake .#asus  --target-host root@100.64.0.7


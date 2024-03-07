

UNAME := $(shell uname)
HOSTNAME := $(shell hostname)
TARTGET = ""

home:
ifeq ($(TARGET), "")
	home-manager switch --flake ".#${USER}@${HOSTNAME}"
else
	home-manager switch --flake $(TARGET)
endif



switch:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nix-collect-garbage -d
	sudo nixos-rebuild switch --flake ".#"
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

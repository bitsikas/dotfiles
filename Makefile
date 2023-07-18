

UNAME := $(shell uname)
HOSTNAME := $(shell hostname)
switch:
ifeq ($(UNAME), Darwin)
	home-manager switch --flake ".#${USER}@${HOSTNAME}"
else
	sudo nixos-rebuild switch --flake ".#"
endif


boot:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nixos-rebuild boot --flake ".#"
endif


test:
ifeq ($(UNAME), Darwin)
	echo "skipping"
else
	sudo nixos-rebuild test --flake ".#"
endif

#!/bin/bash
mkdir -p ~/.config/lights/

case $1 in
		on)
				kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Latte;
				for server in $(nvr --serverlist); do
						nvr --servername "$server"  -c "set background=light";
				done
				yes | fish -c 'fish_config theme save "Catppuccin Latte"';
				;;
		off)
				kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Frappe;
				for server in $(nvr --serverlist); do
						nvr --servername "$server"  -c "set background=dark";
				done
				yes | fish -c 'fish_config theme save "Catppuccin Frappe"';
				;;
		*)
esac;


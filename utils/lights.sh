#!/bin/bash
mkdir -p ~/.config/lights/

case $1 in
		on)
				kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Latte
				for server in $(nvr --serverlist); do
						nvr --servername "$server"  -c "set background=light";
				done
				;;
		off)
				kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Frappe
				for server in $(nvr --serverlist); do
						nvr --servername "$server"  -c "set background=dark";
				done
				
				;;
		*)
esac;


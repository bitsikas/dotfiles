{ config, pkgs, ... }:
{
  xdg.configFile."wofi/config".text = (builtins.readFile .config/wofi/config);
  xdg.configFile."wofi/style.css".text = (builtins.readFile .config/wofi/style.css);
}

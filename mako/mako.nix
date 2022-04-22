
{ config, pkgs, ... }:
{
  xdg.configFile."mako/config".text = (builtins.readFile .config/mako/config);
}

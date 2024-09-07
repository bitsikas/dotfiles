{ inputs, ... }:

{ config, lib, pkgs, ... }:
{
    home.username = "kostas";
    home.homeDirectory = "/home/kostas";
    home.stateVersion = "21.11";
    home.sessionVariables = { "EDITOR" = "nvim"; };
    imports = [ ../../desktop.nix ../../cli.nix ../../linux.nix ];
}

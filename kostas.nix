{ config, pkgs, lib, ... }:
{

  home.username = "kostas";
  home.homeDirectory = "/home/kostas";

  imports = [
    ./desktop.nix
    ./cli.nix
    ./home.nix
  ];

}


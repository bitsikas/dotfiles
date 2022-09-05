{ config, pkgs, lib, ... }:
{

  home.username = "Kostas.Papakon";
  home.homeDirectory = "/Users/Kostas.Papakon";

  imports = [
    ./cli.nix
    ./home.nix
  ];

}


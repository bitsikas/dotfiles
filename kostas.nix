{ config, pkgs, lib, ... }:
{

  home.username = "kostas";
  home.homeDirectory = "/home/kostas";
  #nixpkgs.config.allowUnfree = true;

  imports = [
    ./desktop.nix
    ./cli.nix
    ./home.nix
  ];

}


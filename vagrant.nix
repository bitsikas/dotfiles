{ config, pkgs, lib, ... }:
{

  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";

  imports = [
    ./cli.nix
    ./home.nix
  ];

}


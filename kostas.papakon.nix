{ config, pkgs, lib, ... }: {

  home.username = "Kostas.Papakon";
  home.stateVersion = "22.05";
  home.homeDirectory = "/Users/Kostas.Papakon";
  nixpkgs.config.permittedInsecurePackages = [
                "nodejs-16.20.0"
              ];

  imports = [ ./cli.nix ./home.nix kitty/kitty.nix ./mac.nix];

}


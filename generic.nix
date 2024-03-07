
{ config, pkgs, lib, ... }: {

  # nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "Kostas.Papakon";
  home.homeDirectory = "/home/Kostas.Papakon";
  home.stateVersion = "23.05";
  home.sessionVariables = {
    "EDITOR" = "nvim";
    "TERMINAL" = "kitty";
  };
  nixpkgs.config.permittedInsecurePackages = [
                "nodejs-16.20.2"
              ];
}

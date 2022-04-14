{ config, pkgs, lib, ... }:
{
  home.stateVersion = "21.11";

  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.sessionVariables = {
    "EDITOR" = "nvim";
  };

  home.packages = with pkgs; [
    nordic
  ];
}

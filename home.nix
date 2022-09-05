{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.05";

  # nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.sessionVariables = {
    "EDITOR" = "nvim";
  };
}


{ config, pkgs, lib, ... }: {

  # nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    "EDITOR" = "nvim";
    "TERMINAL" = "kitty";
  };
}

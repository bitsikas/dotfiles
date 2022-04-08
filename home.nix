{ config, pkgs, lib, ... }:
{
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nordic
  ];
}

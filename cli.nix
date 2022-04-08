
{ config, pkgs, lib, ... }:
{
  imports = [
    fish/fish.nix
    nvim/nvim.nix
    kitty/kitty.nix
    git/git.nix
  ];
  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.bat.enable = true;
  programs.gh.enable = true;
  programs.direnv.enable = true;
  home.packages = with pkgs; [
    nordic
    visidata
  ];
}


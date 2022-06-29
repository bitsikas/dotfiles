
{ config, pkgs, lib, ... }:
let
  unstable = import (
    fetchTarball  https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz 
    ){ config = { allowUnfree = true; }; };
in {
  imports = [
    fish/fish.nix
    nvim/nvim.nix
    git/git.nix
    bat/bat.nix
  ];
  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.gh.enable = true;
  programs.gh.settings =  {
    git_protocol = "ssh";
    prompt = "enabled";
  };
  programs.gh.package = unstable.gh;

  programs.direnv.enable = true;
  home.packages = with pkgs; [
    visidata
    gnumake
    httpie
    htop
    go
    gopls
    rnix-lsp
    gcc
    nodejs
    python39
    ranger
    ripgrep
    rq
    stow
    tmux
    unrar
    pipenv
    wget
  ];
}


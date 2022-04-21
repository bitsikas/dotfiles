
{ config, pkgs, lib, ... }:
{
  imports = [
    fish/fish.nix
    nvim/nvim.nix
    git/git.nix
  ];
  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.bat.enable = true;
  programs.gh.enable = true;
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
    imv
  ];
}


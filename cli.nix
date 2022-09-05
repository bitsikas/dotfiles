
{ config, pkgs, lib, ... }:
{
  imports = [
    fish/fish.nix
    nvim/nvim.nix
    git/git.nix
    bat/bat.nix
  ];
  programs.home-manager.enable = true;
  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.gh.enable = true;
  programs.gh.settings =  {
    git_protocol = "ssh";
    prompt = "enabled";
  };

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


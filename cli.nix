{ config, pkgs, lib, nixpkgs-unstable, ... }: {
  imports = [
    fish/fish.nix
    nvim/nvim.nix
    git/git.nix
    bat/bat.nix
    starship/starship.nix
    tmux/tmux.nix
  ];
  programs.home-manager.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;
  programs.gh.settings = {
    git_protocol = "ssh";
    prompt = "enabled";
  };

  programs.ssh = {
    enable = true;
    controlMaster = "yes";
    controlPersist = "yes";
    forwardAgent = true;
    compression = true;
    includes = [ "config.d/*" ];
  };

  programs.git.package = nixpkgs-unstable.git;
  programs.direnv.enable = true;
  home.packages = with pkgs; [
    # unrar
    nixpkgs-unstable.devbox
    dnsutils
    docker
    nixpkgs-unstable.eza
    gcc
    gnumake
    gnupg
    go
    gopls
    htop
    httpie
    nixfmt
    nodejs-18_x
    pass
    pipenv
    python39
    ranger
    ripgrep
    rnix-lsp
    rq
    stow
    # taskell
    tmux
    visidata
    wget
  ];
}


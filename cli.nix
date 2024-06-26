{ config, pkgs, lib, nixpkgs-unstable, ... }: {
  imports = [
    bat/bat.nix
    fish/fish.nix
    git/git.nix
    nvim/nvim.nix
    ranger/ranger.nix
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
#  programs.direnv.package = pkgs.nix-direnv-flakes;
  home.packages = with pkgs; [
    # unrar
    _7zz
    nix-direnv-flakes
    nixpkgs-unstable.devbox
    dnsutils
    # docker
    nixpkgs-unstable.eza
    gcc
    gnumake
    gnupg
    go
    gopls
    htop
    httpie
    # nixfmt
    nodejs-18_x
    pass
    pandoc
    ranger
    ripgrep
    rq
    stow
    # taskell
    tmux
    unzip
    visidata
    wget
    (pkgs.writeShellApplication {
      name = "lights";
      runtimeInputs = with pkgs; [ neovim-remote ];
      text = (builtins.readFile ./utils/lights.sh);
    })

  ];
}


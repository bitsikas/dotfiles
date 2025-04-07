{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}: {
  imports = [
    ./bat/bat.nix
    ./fish/fish.nix
    ./git/git.nix
    ./nvim/nvim.nix
    ./ranger/ranger.nix
    ./starship/starship.nix
    ./tmux/tmux.nix
    ./nushell/nushell.nix
  ];

  programs.home-manager.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.gh.settings = {
    git_protocol = "ssh";
    prompt = "enabled";
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "60m";
    controlPath = "~/.c-%r@%n";
    forwardAgent = true;
    compression = true;
    includes = ["config.d/*"];
  };

  programs.git.package = nixpkgs-unstable.git;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  #  programs.direnv.package = pkgs.nix-direnv-flakes;
  home.packages = with pkgs; [
    _7zz
    alejandra
    nixfmt-rfc-style
    dnsutils
    ffmpeg
    gnupg
    htop
    eza
    pass
    ranger
    ripgrep
    rq
    tmux
    wget
    ruff
    pyright
    zoxide
    (pkgs.writeShellApplication {
      name = "lights";
      runtimeInputs = with pkgs; [neovim-remote];
      text = builtins.readFile ../utils/lights.sh;
    })
  ];
}

{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ./bat/bat.nix
    ./fish/fish.nix
    ./git/git.nix
    ./nvim/nvim.nix
    ./ranger/ranger.nix
    ./starship/starship.nix
    ./tmux/tmux.nix
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
    # controlMaster = "yes";
    # controlPersist = "yes";
    # controlPath = "~/.c-%r@%n";
    forwardAgent = true;
    compression = true;
    includes = [ "config.d/*" ];
  };

  programs.git.package = nixpkgs-unstable.git;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  #  programs.direnv.package = pkgs.nix-direnv-flakes;
  home.packages = with pkgs; [
    _7zz
    dnsutils
    ffmpeg
    gnupg
    htop
    httpie
    eza
    pass
    ranger
    ripgrep
    rq
    tmux
    wget
    (pkgs.writeShellApplication {
      name = "lights";
      runtimeInputs = with pkgs; [ neovim-remote ];
      text = (builtins.readFile ../utils/lights.sh);
    })
  ];
}

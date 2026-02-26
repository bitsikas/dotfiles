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
    # ./nushell/nushell.nix
    ./options.nix
  ];
  config = {
    programs.home-manager.enable = true;
    programs.fzf = lib.mkIf config.myFeatures.desktop {
      enable = true;
    };
    programs.zoxide = lib.mkIf config.myFeatures.desktop {
      enable = true;
    };
    programs.gh = lib.mkIf config.myFeatures.desktop {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    programs.ssh = {
      enable = true;
      includes = ["config.d/*"];
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          addKeysToAgent = "no";
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPersist = "60m";
          controlPath = "~/.c-%r@%n";
          forwardAgent = true;
          compression = true;
        };
      };
    };

    programs.git.package = nixpkgs-unstable.git;
    programs.direnv = lib.mkIf config.myFeatures.desktop {
      enable = true;
      nix-direnv.enable = true;
    };
    #  programs.direnv.package = pkgs.nix-direnv-flakes;
    home.packages = with pkgs;
      [
        _7zz
        dnsutils
        ffmpeg
        gnupg
        htop
        eza
        pass
        ripgrep
        rq
        tmux
        wget
        # (pkgs.writeShellApplication {
        #   name = "lights";
        #   runtimeInputs = with pkgs; [neovim-remote];
        #   text = builtins.readFile ../utils/lights.sh;
        # })
      ]
      ++ lib.optionals config.myFeatures.desktop [
        alejandra
        d2
        glow
        jupyter
        nixfmt-rfc-style
        presenterm
        pyright
        ranger
        ruff
        todo-txt-cli
        uv
        visidata
        zoxide
      ];
  };
}

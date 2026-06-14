{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  inputs,
}: user: {
  system,
  darwin ? false,
}: let
  homedir =
    if darwin
    then "/Users/${user}/"
    else "/home/${user}/";
  platform =
    if darwin
    then "macos"
    else "linux";
  platformConfig = ../users/${user}/${platform}.nix;
  homeFunc = home-manager.lib.homeManagerConfiguration;

  # Instantiate unstable nixpkgs once, not per module
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
  homeFunc rec {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      {
        home.username = user;
        home.homeDirectory = homedir;
        home.sessionVariables = {
          "EDITOR" = "nvim";
          "TERMINAL" = "ghostty";
        };
      }
      {fonts.fontconfig.enable = true;}
      {programs.home-manager.enable = true;}
      {nixpkgs.config.allowUnfree = true;}
      {
        nixpkgs.overlays = [
          inputs.neorg-overlay.overlays.default
          inputs.llm-agents.overlays.default
        ];
      }
      {
        nixpkgs.config.permittedInsecurePackages = [
          "nodejs-16.20.0"
          "nodejs-16.20.2"
        ];
      }
      platformConfig
      {home.stateVersion = "23.05";}
      ../modules/cli.nix
      {
        _module.args.nixpkgs-unstable = unstable;
      }
    ];
  }

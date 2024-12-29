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
in
  homeFunc rec {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      {
        home.username = user;
        home.homeDirectory = homedir;
        home.sessionVariables = {
          "EDITOR" = "nvim";
          "TERMINAL" = "kitty";
        };
      }
      {fonts.fontconfig.enable = true;}
      {programs.home-manager.enable = true;}
      {nixpkgs.config.allowUnfree = true;}
      {
        nixpkgs.config.permittedInsecurePackages = [
          "nodejs-16.20.0"
          "nodejs-16.20.2"
        ];
      }
      platformConfig
      {home.stateVersion = "23.05";}
      ../modules/cli.nix
      (
        {pkgs, ...}: rec {
          _module.args.nixpkgs-unstable = import nixpkgs-unstable {inherit system;};
        }
      )
    ];
  }

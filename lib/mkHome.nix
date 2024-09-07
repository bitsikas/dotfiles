{ nixpkgs, nixpkgs-unstable, home-manager, inputs }:

user:
{
  system,
  darwin ? false
}:

let
  homeDirectory = '/${if darwin "Users" else "home"}/${user}';
  userHMConfig = ../users/${user}/home.nix;
  homeFunc = home-manager.lib.homeManagerConfiguration

in homeFunc rec { 

    inherit system;
    pkgs = nixpkgs.legacyPackages.${system};
    username = user;
    home.homeDirectory = homeDirectory;
    home.sessionVariables = {
      "EDITOR" = "nvim";
      "TERMINAL" = "kitty";
    };
    modules = [
      {
        fonts.fontconfig.enable = true;
      }
      { programs.home-manager.enable = true; }
      { nixpkgs.config.allowUnfree = true; }
      {
        nixpkgs.config.permittedInsecurePackages = [
          "nodejs-16.20.0"
          "nodejs-16.20.2"
        ];
      }
      {
        home.stateVersion = "23.05";
      }
      ./cli.nix 
      ({ pkgs, ... }: rec {
        _module.args.nixpkgs-unstable =
          import nixpkgs-unstable { inherit system; };
      })
    ];
  }


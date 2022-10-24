{
  description = "Nix configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        # devShells.default = import ./shell.nix { inherit pkgs; };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.openssh
            pkgs.rsync # Included by default on NixOS
            pkgs.nixFlakes
            pkgs.git
          ];
        };
      }) // {
        homeConfigurations = (let system = "x86_64-darwin";
        in rec {
          "Kostas.Papakon@PKOSTAS-MB" =
            home-manager.lib.homeManagerConfiguration {
              username = "Kostas.Papakon";
              system = "x86_64-darwin";
              homeDirectory = "/Users/Kostas.Papakon";
              configuration = import ./kostas.papakon.nix;
              # modules = [ ./cli.nix ./home.nix ] ;

            };
        });

        nixosConfigurations = {
          qemu = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              ./hardware/qemu.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.kostas = {
                  home.username = "kostas";
                  home.homeDirectory = "/home/kostas";
                  home.stateVersion = "22.05";
                  home.sessionVariables = { "EDITOR" = "nvim"; };
                  imports = [ ./desktop.nix ./cli.nix ];
                };
              }
            ];
            # Example how to pass an arg to configuration.nix:
            specialArgs = inputs;
          };
          spectre = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              ./hardware/spectre.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.kostas = {
                  home.username = "kostas";
                  home.homeDirectory = "/home/kostas";
                  home.stateVersion = "21.11";
                  home.sessionVariables = { "EDITOR" = "nvim"; };
                  imports = [ ./desktop.nix ./cli.nix ];
                };
              }
            ];
            # Example how to pass an arg to configuration.nix:
            specialArgs = inputs;
          };
        };
      };
}

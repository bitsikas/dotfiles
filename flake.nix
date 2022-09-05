{
  description = "Nix configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, ... }: 

     flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };
          homeConfigurations = {
            "kostas.papakon@PKOSTAS-MB" = home-manager.lib.homeManagerConfiguration {
              configuration = import ./kostas.nix;
              system = "x86_64-darwin";
            };
          };

          nixosConfigurations = {
            spectre = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [ 
                ./configuration.nix 
                ./hardware/spectre.nix 
                home-manager.nixosModules.home-manager {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true; 
                  home-manager.users.kostas = {
                    home.username = "kostas";
                    home.homeDirectory = "/home/kostas";
                    home.stateVersion = "21.11";
                    home.sessionVariables = {
                      "EDITOR" = "nvim";
                    };
                    imports = [
                      ./desktop.nix
                      ./cli.nix
                    ];
                  };
                }
              ];
              # Example how to pass an arg to configuration.nix:
              # specialArgs = { hostname = "spectre"; };
            }; 
          };
        }
    );
}

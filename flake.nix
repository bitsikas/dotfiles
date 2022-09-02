{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
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
          #./hardware/spectre.nix 
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true; 
            home-manager.users.kostas = (import ./kostas.nix);
          }
        ];
        # Example how to pass an arg to configuration.nix:
        # specialArgs = { hostname = "spectre"; };
      }; 
    };
  };
}

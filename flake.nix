{
  description = "Nix configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, flake-utils, nixpkgs-unstable, nixos-hardware, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        unstable-pkgs = import nixpkgs-unstable { inherit system; };
      in {
        # devShells.default = import ./shell.nix { inherit pkgs; };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.openssh
            pkgs.rsync # Included by default on NixOS
            pkgs.nixFlakes
            pkgs.home-manager
            unstable-pkgs.git
            
          ];
        };
      }) // {
        homeConfigurations = (let system = "x86_64-darwin";
        in {
          "Kostas.Papakon@PKOSTAS-MB" =
            home-manager.lib.homeManagerConfiguration {
              pkgs = nixpkgs.legacyPackages.${system};
              # username = "Kostas.Papakon";
              # system = "x86_64-darwin";
              # homeDirectory = "/Users/Kostas.Papakon";
              # configuration = import ./kostas.papakon.nix;
              modules = [
                # ./kostas.papakon.nix
                ./cli.nix 
                ./home.nix 
                ./kitty/kitty.nix 
                ./mac.nix

                ({ pkgs, ... }: rec {
                  _module.args.nixpkgs-unstable =
                    import nixpkgs-unstable { inherit system; };
                  })

              ];

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
          spectre = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              # ./linux.nix
              ./hardware/spectre.nix
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-gpu-intel
              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-laptop-acpi_call
              nixos-hardware.nixosModules.common-pc-laptop-ssd
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { nixpkgs-unstable =  import nixpkgs-unstable { inherit system; }; };
                home-manager.users.kostas = {
                  home.username = "kostas";
                  home.homeDirectory = "/home/kostas";
                  home.stateVersion = "21.11";
                  home.sessionVariables = { "EDITOR" = "nvim"; };
                  imports = [ ./desktop.nix ./cli.nix ./linux.nix ];
                };
              }
            ];
            # Example how to pass an arg to configuration.nix:
            specialArgs = inputs;
          };
        };
      };
}

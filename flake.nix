{
  description = "Nix configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, flake-utils, nixpkgs-unstable, nixos-hardware, nixos-generators, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        unstable-pkgs = import nixpkgs-unstable { inherit system; };
      in {
        # devShells.default = import ./shell.nix { inherit pkgs; };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.openssh
            pkgs.rsync # Included by default on NixOS
            pkgs.nixFlakes
            pkgs.home-manager
            unstable-pkgs.git
            
          ];
        };
      }) // {

        packages.aarch64-linux = let 
          rawkeys = builtins.readFile (builtins.fetchurl {
                      url = "https://github.com/bitsikas.keys";
                      sha256 = "1rbxms3pv6msfyhds2bc0haza34fhvy3ya9qj5k30i11xd8sapmv";
                    });
          listkeys = nixpkgs.lib.strings.splitString "\n" rawkeys;
          goodlistkeys = nixpkgs.lib.trace listkeys builtins.filter (x: x != "") listkeys;
                  

        in{
          sdcard = nixos-generators.nixosGenerate {
            system = "aarch64-linux";
            format = "sd-aarch64";
            modules = [

              ({
                console.enable = false;
                environment.systemPackages = with nixpkgs.legacyPackages.aarch64-linux; [
                  libraspberrypi
                  raspberrypi-eeprom
                ];
                system.stateVersion = "24.05";
                sdImage.compressImage=false;
                networking = {
                  hostName = "beershot";
                };
                services.avahi.enable = true;
                services.openssh.enable = true;
                disabledModules = [
                  "profiles/base.nix"
                ];

                users.users = {
                  root = {
                    password = "root";
                    openssh.authorizedKeys.keys = goodlistkeys; 
                  };
                };
              }
              )
            ];
          };
        };

        homeConfigurations = (let system = "x86_64-darwin";
        in {
          "Kostas.Papakon@MB-C02DQ48VMD6T" =
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

            };}) // (let system = "x86_64-linux";
            in {
          "linuxcli" = 
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
                ./generic.nix 

                ({ pkgs, ... }: rec {
                  _module.args.nixpkgs-unstable =
                    import nixpkgs-unstable { inherit system; };
                  })

              ];

            };
          
        });

      nixosConfigurations = let 
        mkSystem = import ./lib/mkSystem.nix {
          inherit nixpkgs inputs nixpkgs-unstable nixos-hardware;
        };
      in{
          qemu = nixpkgs.lib.nixosSystem rec {
            system = "aarch64-linux";
            modules = [
              ./configuration.nix
              ./hardware/qemu.nix
              ./qemu.nix
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
        spectre = mkSystem "spectre" {
          system = "x86_64-linux";
          user = "kostas";
        };
          # spectre = nixpkgs.lib.nixosSystem rec {
          #   system = "x86_64-linux";
          #   modules = [
          #     ./configuration.nix
          #     # ./linux.nix
          #     ./hardware/spectre.nix
          #     ./printing.nix
          #     nixos-hardware.nixosModules.common-cpu-intel
          #     # nixos-hardware.nixosModules.common-cpu-intel.tiger-lake
          #     # nixos-hardware.nixosModules.common-gpu-intel
          #     nixos-hardware.nixosModules.common-pc-laptop
          #     nixos-hardware.nixosModules.common-pc-laptop-acpi_call
          #     nixos-hardware.nixosModules.common-pc-laptop-ssd
          #     home-manager.nixosModules.home-manager
          #     {
          #       home-manager.useGlobalPkgs = true;
          #       home-manager.useUserPackages = true;
          #       home-manager.extraSpecialArgs = { nixpkgs-unstable =  import nixpkgs-unstable { inherit system; }; };
          #       home-manager.users.kostas = {
          #         home.username = "kostas";
          #         home.homeDirectory = "/home/kostas";
          #         home.stateVersion = "21.11";
          #         home.sessionVariables = { "EDITOR" = "nvim"; };
          #         imports = [ ./desktop.nix ./cli.nix ./linux.nix ];
          #       };
          #     }
          #   ];
          #   # Example how to pass an arg to configuration.nix:
          #   # specialArgs = inputs;
          #   specialArgs.nixpkgs-unstable =  import nixpkgs-unstable { inherit system; };
          # };
          pi4 = nixpkgs.lib.nixosSystem rec {
            system = "aarch64-linux";
            modules = [
              ./pi-config.nix
              ./hardware/pi4.nix
              nixos-hardware.nixosModules.raspberry-pi-4
            ];
            # Example how to pass an arg to configuration.nix:
            # specialArgs = inputs;
          };
        };
      };
}

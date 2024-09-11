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

        packages.aarch64-linux = {
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
                  openssh.authorizedKeys.keys = [
                   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
                  ]; 
                  };
                };
              }
              )
            ];
          };
        };

      homeConfigurations = let
        mkHome = import ./lib/mkHome.nix {
          inherit nixpkgs inputs nixpkgs-unstable home-manager;
        };
      in {
        "Kostas.Papakon@MB-C02DQ48VMD6T" = mkHome "Kostas.Papakon" {
          system = "x86_64-darwin";
          darwin = true;
        }; 
        "kostas.papakonstantinou@MB-L33Y5V90G5T" = mkHome "kostas.papakonstantinou" {
          system = "aarch64-darwin";
          darwin = true;
        }; 
        "linuxcli" = mkHome "kp" {
          system = "x86_64-linux";
        }; 
      };

      nixosConfigurations = let 
        mkSystem = import ./lib/mkSystem.nix {
          inherit nixpkgs inputs nixpkgs-unstable nixos-hardware;
        };
      in{
        qemu-aarch64 = mkSystem "vm-qemu-aarch64" { 
          system = "aarch64-linux";
          user = "kostas";
        };
        qemu-x86_64 = mkSystem "vm-qemu-x86_64" { 
          system = "aarch64-linux";
          user = "kostas";
        };
        spectre = mkSystem "spectre" {
          system = "x86_64-linux";
          user = "kostas";
        };
        beershot = mkSystem "pi4" {
          system = "aarch64-linux";
          user = "kostas";
        };
      #   pi4 = nixpkgs.lib.nixosSystem rec {
      #     system = "aarch64-linux";
      #     modules = [
      #       ./pi-config.nix
      #       ./hardware/pi4.nix
      #       nixos-hardware.nixosModules.raspberry-pi-4
      #     ];
      #     # Example how to pass an arg to configuration.nix:
      #     # specialArgs = inputs;
      #   };
      };
    };
}

{
  description = "Nix configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # pdfblancs.url = "git+ssh://git@github.com/bitsikas/pdfblanks";
    # pdfblancs.inputs.nixpkgs.follows = "nixpkgs";
    artframe.url = "git+ssh://git@github.com/bitsikas/artframe";
    artframe.inputs.nixpkgs.follows = "nixpkgs";
    fittrack.url = "git+ssh://git@github.com/bitsikas/fittrack";
    fittrack.inputs.nixpkgs.follows = "nixpkgs";
    milia.url = "git+ssh://git@github.com/bitsikas/milia";
    milia.inputs.nixpkgs.follows = "nixpkgs";
    liverecord.url = "git+ssh://git@github.com/bitsikas/liverecord";
    liverecord.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    ihasb33r = {
      url = "git+ssh://git@github.com/bitsikas/ihasb33r";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ghostty = {
    #   url = "github:ghostty-org/ghostty/v1.1.3";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    nixpkgs-unstable,
    nixos-hardware,
    nixos-generators,
    disko,
    # ghostty,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        unstable-pkgs = import nixpkgs-unstable {inherit system;};
      in {
        mkHome = import ./lib/mkHome.nix {
          inherit
            nixpkgs
            inputs
            nixpkgs-unstable
            home-manager
            ;
        };
        mkSystem = import ./lib/mkSystem.nix {
          inherit
            nixpkgs
            inputs
            nixpkgs-unstable
            nixos-hardware
            disko
            ;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.openssh
            pkgs.rsync # Included by default on NixOS
            # pkgs.nixFlakes
            pkgs.nixVersions.stable
            pkgs.home-manager
            unstable-pkgs.git
            pkgs.docker
          ];
        };
      }
    )
    // {
      homeConfigurations = let
        mkHome = import ./lib/mkHome.nix {
          inherit
            nixpkgs
            inputs
            nixpkgs-unstable
            home-manager
            ;
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
        "linuxcli" = mkHome "kp" {system = "x86_64-linux";};
        "aarch64cli" = mkHome "kp" {system = "aarch64-linux";};
      };

      nixosConfigurations = let
        mkSystem = import ./lib/mkSystem.nix {
          inherit
            nixpkgs
            inputs
            nixpkgs-unstable
            nixos-hardware
            disko
            ;
        };
      in {
        qemu-aarch64 = mkSystem "vm-qemu-aarch64" {
          system = "aarch64-linux";
          users = ["kostas"];
        };
        qemu-x86_64 = mkSystem "vm-qemu-x86_64" {
          system = "aarch64-linux";
          users = ["kostas"];
        };
        spectre = mkSystem "spectre" {
          system = "x86_64-linux";
          users = ["kostas" "guest" "root"];
        };
        beershot = mkSystem "pi4" {
          system = "aarch64-linux";
          users = ["root"];
        };
        devserver = mkSystem "devserver" {
          system = "x86_64-linux";
          users = ["kostas" "root"];
          usedisko = true;
        };
        asus = mkSystem "asus" {
          system = "x86_64-linux";
          users = ["kostas" "root"];
        };
        hetzner-cloud = mkSystem "hetzner-cloud" {
          system = "x86_64-linux";
          users = ["root"];
          usedisko = true;
        };
      };
    };
}

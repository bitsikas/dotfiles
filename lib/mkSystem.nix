# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  inputs,
  disko,
}: name: {
  system,
  users,
  usedisko ? false,
}: let
  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfigs = builtins.map (user: ../users/${user}/nixos.nix) users;
  userHMConfigs =
    builtins.map (
      user: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = ".nixbak";
        home-manager.extraSpecialArgs = {
          nixpkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        home-manager.users.${user} = import ../users/${user}/home.nix {inputs = inputs;};
      }
    )
    (builtins.filter (user: builtins.pathExists ../users/${user}/home.nix) users);
  diskoConfig = ../disks/${name}.nix;
  withDisko = usedisko;
  machineName = name;

  # NixOS
  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules =
      [
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        {
          nixpkgs.overlays = [
            # inputs.pdfblancs.overlays.${system}.default
            # inputs.artframe.overlays.${system}.default
            # inputs.fittrack.overlays.${system}.default
            # inputs.ihasb33r.overlays.${system}.default
            # inputs.milia.overlays.${system}.default
          ];
        }

        # Allow unfree packages.
        {
          nixpkgs.config.allowUnfree = true;
        }
        #{ nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ]; }
        (
          if withDisko
          then disko.nixosModules.disko
          else {}
        )
        (
          if withDisko
          then diskoConfig
          else {}
        )
        # inputs.pdfblancs.nixosModules.default
        inputs.artframe.nixosModules.default
        inputs.fittrack.nixosModules.default
        inputs.ihasb33r.nixosModules.default
        inputs.milia.nixosModules.default
        inputs.liverecord.nixosModules.default

        inputs.nix-index-database.nixosModules.nix-index

        machineConfig
        # userOSConfig
        home-manager.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.extraSpecialArgs = {
        #     nixpkgs-unstable = import nixpkgs-unstable {
        #       inherit system;
        #       config.allowUnfree = true;
        #     };
        #   };
        #   home-manager.users.${user} = import userHMConfig {inputs = inputs;};
        # }

        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            currentSystem = system;
            currentSystemName = name;
            # currentSystemUser = user;
            inputs = inputs;
          };
        }
      ]
      ++ userOSConfigs ++ userHMConfigs;
    specialArgs.nixpkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs.nixos-hardware = nixos-hardware;
    specialArgs.inputs = inputs;
  }

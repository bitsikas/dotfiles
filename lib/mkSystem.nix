# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  inputs,
  disko,
  microvm,
}: name: {
  system,
  users,
  usedisko ? false,
  vm ? false,
}: let
  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfigs = builtins.map (user: ../users/${user}/nixos.nix) users;
  diskoConfig = ../disks/${name}.nix;
  withDisko = usedisko;
  machineName = name;

  # Instantiate unstable nixpkgs once, not per module or user
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  userHMConfigs =
    builtins.map (
      user: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = ".nixbak";
        home-manager.extraSpecialArgs = {
          inherit unstable;
          nixpkgs-unstable = unstable;
        };
        home-manager.users.${user} = import ../users/${user}/home.nix {inputs = inputs;};
      }
    )
    (builtins.filter (user: builtins.pathExists ../users/${user}/home.nix) users);

  # NixOS
  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules =
      [
        ../modules/options.nix
        # Apply our overlays. Overlays are keyed by system type so we have
        # to go through and apply our system type. We do this first so
        # the overlays are available globally.
        {
          nixpkgs.overlays = [
            inputs.neorg-overlay.overlays.default
            inputs.llm-agents.overlays.default
          ];
        }

        # Allow unfree packages.
        {
          nixpkgs.config.allowUnfree = true;
        }
        (
          if vm
          then microvm.nixosModules.microvm
          else {}
        )
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
        inputs.artframe.nixosModules.default
        inputs.fittrack.nixosModules.default
        inputs.ihasb33r.nixosModules.default
        inputs.smtping.nixosModules.default
        inputs.milia.nixosModules.default
        inputs.liverecord.nixosModules.default

        inputs.nix-index-database.nixosModules.nix-index

        machineConfig
        home-manager.home-manager

        # We expose some extra arguments so that our modules can parameterize
        # better based on these values.
        {
          config._module.args = {
            inherit unstable;
            currentSystem = system;
            currentSystemName = name;
            inputs = inputs;
          };
        }
      ]
      ++ userOSConfigs ++ userHMConfigs;
    specialArgs = {
      inherit unstable;
      nixpkgs-unstable = unstable;
      nixos-hardware = nixos-hardware;
      inputs = inputs;
    };
  }

# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, nixpkgs-unstable, nixos-hardware, inputs }:

name:
{
  system,
  user
}:

let

  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${user}/nixos.nix;
  userHMConfig = ../users/${user}/home.nix;

  # NixOS 
  systemFunc =  nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    # { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }


    machineConfig
    userOSConfig
    home-manager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { nixpkgs-unstable =  import nixpkgs-unstable { inherit system; }; };
      home-manager.users.${user} = import userHMConfig {
        # isWSL = isWSL;
        inputs = inputs;
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        inputs = inputs;
      };
    }
  ];
  specialArgs.nixpkgs-unstable =  import nixpkgs-unstable {inherit system;};
  specialArgs.nixos-hardware =  nixos-hardware;
  specialArgs.inputs = inputs;

}

# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  inputs,
  disko,
}:

name:
{
  system,
  user,
  usedisko ? false,
}:

let

  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${user}/nixos.nix;
  userHMConfig = ../users/${user}/home.nix;
  diskoConfig = ../disks/${name}.nix;
  withDisko = usedisko;
  machineName = name;

  # NixOS 
  systemFunc = nixpkgs.lib.nixosSystem;
  home-manager = inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;

  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    {
      nixpkgs.overlays = [
        inputs.pdfblancs.overlays.${system}.default
        inputs.artframe.overlays.${system}.default
      ];
    }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }
    { nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ]; }
    (if withDisko then disko.nixosModules.disko else { })
    (if withDisko then diskoConfig else { })
    inputs.pdfblancs.nixosModules.default
    inputs.artframe.nixosModules.default

    machineConfig
    userOSConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        nixpkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      home-manager.users.${user} = import userHMConfig { inputs = inputs; };
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
  specialArgs.nixpkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  specialArgs.nixos-hardware = nixos-hardware;
  specialArgs.inputs = inputs;

}

{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      nixos-hardware.nixosModules.raspberry-pi-4
      (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ];

  hardware.raspberry-pi."4".fkms-3d.enable = true;


  fileSystems."/mnt" =
    { device = "/dev/disk/by-uuid/3ce9b738-c5e0-49e1-bc52-691004679aec";
      fsType = "ext4";
      options = ["nofail"];
      depends = ["/" ];
    };

  swapDevices = [ ];

  # networking.interfaces.end0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

}

# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
  ];


  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" "coretemp"];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = [ "i8042.nopnp=1" "i8042.dumbkbd=1" ];
  boot.loader.systemd-boot.enable = true;
  hardware.opengl.extraPackages = [
    pkgs.intel-compute-runtime
  ];

   boot.extraModprobeConfig = ''
   options snd-intel-dspcfg dsp_driver=1
   '';

   fileSystems."/" =
     { device = "/dev/disk/by-uuid/4ba27507-ce64-4b3d-8039-4371fdd680a3";
     fsType = "ext4";
   };

   fileSystems."/boot" =
     { device = "/dev/disk/by-uuid/5073-48D5";
     fsType = "vfat";
   };

   fileSystems."/home" =
     { device = "/dev/disk/by-uuid/bbef1a50-872d-4f34-bba6-187ecb18b7f3";
     fsType = "ext4";
   };

   swapDevices = [ ];

   powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

   hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
   hardware.steam-hardware.enable = true;

   hardware.opentabletdriver.enable = false;
   hardware.bluetooth.enable = true;
   hardware.opengl = {
     enable = true;
   };

   hardware.pulseaudio.enable = false;

 }

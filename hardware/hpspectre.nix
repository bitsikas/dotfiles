{ config, lib, pkgs, modulesPath, ... }:
{

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "i8042.nopnp=1" "i8042.dumbkbd=1" ];
  boot.loader.systemd-boot.enable = true;
  # boot.extraModprobeConfig = ''
  #   options snd-hda-intel
  # '';
  boot.extraModprobeConfig = ''
  options snd-intel-dspcfg dsp_driver=1
  '';
  hardware.opengl.extraPackages = [
    pkgs.intel-compute-runtime
  ];

  hardware.steam-hardware.enable = true;

  # boot.blacklistedKernelModules = ["snd-hda-intel" "snd_soc_skl"];
  # boot.blacklistedKernelModules = ["snd-hda-intel"];
  # boot.kernelParams = [ "i8042.nopnp=1" ];
  # powerManagement.powertop.enable = true;

}


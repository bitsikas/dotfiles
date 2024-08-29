{ config, pkgs, lib, nixpkgs-unstable, ... }: {

  environment.systemPackages = with pkgs; [
    spice-vdagent
  ];
}



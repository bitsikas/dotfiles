# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  nixpkgs-unstable,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # building sd image failes with missing sun4i-drm
  # but it's not necessary to run
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  # boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  # boot.loader.generic-extlinux-compatible.enable = true;
  imports = [./hardware/devserver.nix];

  # systemd.timers."dyndns" = {
  #   wantedBy = ["timers.target"];
  #   timerConfig = {
  #     OnBootSec = "15m";
  #     OnUnitActiveSec = "15m";
  #     Unit = "dynamic-dns-updater.service";
  #   };
  # };
  system.stateVersion = "25.05";
  # systemd.services = {
  #   dynamic-dns-updater = {
  #     path = [pkgs.curl];
  #     script = "cat /etc/dyndns | curl -k -K -";
  #     serviceConfig = {
  #       Type = "oneshot";
  #       User = "root";
  #     };
  #   };
  # };
  security.sudo.enable = true;
  #sdImage.compressImage = false;

  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;

  # avoid building zfs
  disabledModules = ["profiles/base.nix"];
  services.resolved.enable = true;
  services.exim = {
    enable = true;
    config = builtins.readFile ../modules/exim/exim.conf;
  };
  services.haproxy = {
    enable = true;
    config = builtins.readFile ../modules/haproxy/haproxy.conf;
  };
  systemd.tmpfiles.settings = {
    exim = {
      "/var/spool/exim/" = {
        d = {
          mode = "0700";
          user = "exim";
          group = "exim";
        };
      };
    };
  };
  # systemd.services.exim.preStart = "";
  # systemd.services.exim.serviceConfig.ExecStartPre = "+${pkgs.coreutils}/bin/install --group=exim --owner=exim --mode=0700 --directory /var/spool/exim4";

  networking.hostName = "devserver"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall = {
    allowedTCPPorts = [
      22
      25
      80
      443
      587
    ];
    allowedUDPPorts = [
    ];
  };

  networking.useDHCP = lib.mkDefault true;
  # # enable NAT
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "end0";
  # networking.nat.internalInterfaces = ["wg0"];

  networking.nftables.enable = true;

  services.openssh.enable = true;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/LlyXIrquF9XO6MAx95yrwFdnr7JZCbWzjCt1qPcMd "
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCd20DETkIH4liuWJOuobBvAnXNflW+MKHh8Uwz37X3l+1WTyR5VaPhTN1vnAwI+SAYk710eJcG+NGXwyj15Qs3CQXWAMB7pDzB1W8lN9Ihyo5R5x5EgXq7P4VPd3YdfU4Q8BkwF06b+EH39kUCoTfS/1ZbcJVTCptMCm3h7XwPmYBbq+ZuKWFmc+ojcTZw2w/RXYQBisrFVemYIxLUJlVveHCZfLDigyLvk8kx5eu0gHWvoJ+mIXmZcvbMfYFVkCo9eUYqAvNZ11TOjyTNe9Me5B81+oFJsvx23HyKv2CJ8TVbbGNKYkdAtRU+KP5DhGi6S/TDaQf6+qQDp1QXzghb "
    ];
  };

  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    inetutils
  ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
}

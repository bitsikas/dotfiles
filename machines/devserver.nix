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
  services.haproxy = {
    enable = true;
    config = ''
      # ---------------------------------------------------------------------
      # GLOBAL CONFIGURATION
      # ---------------------------------------------------------------------
      global
          log /dev/log    len 4096 local0
          # Define the user and group HAProxy runs as
          user haproxy
          group haproxy
          # Set the maximum number of concurrent connections
          maxconn 2000

      # ---------------------------------------------------------------------
      # FRONTEND (Listens for incoming SMTP connections)
      # ---------------------------------------------------------------------
      frontend fe_smtp
          # Use TCP mode for SMTP
          mode tcp
          # Listen on the standard SMTP port (25) on all interfaces
          bind *:587
          # Default action is to forward traffic to the backend mail servers
          default_backend be_smtp_servers

      # ---------------------------------------------------------------------
      # BACKEND (Defines the actual mail servers)
      # ---------------------------------------------------------------------
      backend be_smtp_servers
          # Use TCP mode
          mode tcp
          # Use a simple round-robin load balancing algorithm
          balance roundrobin
          # Connection timeout should be generous for SMTP
          timeout connect 5s
          timeout server 50s

          # Define your mail server(s) here.
          # Replace the IP addresses/names with your actual backend servers.
          server mail_server_1 someserver.test:587
          # Add more servers as needed
    '';
  };

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

{
  lib,
  config,
  pkgs,
  nixpkgs-unstable,
  inputs,
  ...
}: {
  imports = [./hardware/spectre.nix];

  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixVersions.stable; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;

  environment.sessionVariables = {
    # QT_QPA_PLATFORM = "wayland-egl";
    QT_QPA_PLATFORM = "wayland";
    KWIN_IM_SHOW_ALWAYS = "1";
  };
  networking.networkmanager.enable = true;
  services.pulseaudio.enable = false;
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.cnijfilter2
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.hplip
  ];

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  environment.systemPackages = with pkgs; [
    _1password-cli
    bat
    cifs-utils
    coreutils
    fd
    ffmpeg
    # gnome-boxes
    gnome-tweaks
    gnomeExtensions.gsconnect
    gnomeExtensions.user-themes
    libinput-gestures
    libwacom
    mangal
    pavucontrol
    qt5.qtwayland
    sof-firmware
    transmission-remote-gtk
    vanilla-dmz
    wireguard-tools
    wl-clipboard
    bottles
    chiaki-ng
    firefox-wayland
    dconf
    inkscape
    gimp
    imv
    vlc
    nixpkgs-unstable.krita
    minikube
    skaffold
    kubectl
    libreoffice
    thunderbird
    inputs.ghostty.packages.x86_64-linux.default
  ];
  programs.light.enable = true;
  programs.kdeconnect.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.plasma5Packages.ksshaskpass.out}/bin/kssaskpass";
  # programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  security.rtkit.enable = true;
  security.sudo.enable = true;

  # networking.firewall.allowedTCPPorts = [8000];
  # networking.firewall.allowedUDPPorts = [];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.mullvad-vpn.enable = true;
  services.blueman.enable = true;
  services.dbus = {
    enable = true;
    packages = with pkgs; [pkgs.dconf];
  };
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.avahi = {
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
    enable = true;
    nssmdns4 = true;
  };
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = false;
      gdm.enable = true;
      gdm.wayland = true;
      gdm.debug = false;
    };
    desktopManager = {
      gnome.enable = true;
      gnome.debug = false;
    };
    # wacom.enable = true;
  };
  #  services.displayManager.ly.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    defaultSession = "gnome";
  };
  # virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  system.stateVersion = "22.05";
  # systemd.services = {
  #   audio-fixer = {
  #     path = [pkgs.alsa-tools];
  #     script = (builtins.readFile ../utils/fixhpspeaker.sh);
  #     serviceConfig = {
  #       Type = "oneshot";
  #       User = "root";
  #     };
  #   };
  # };

  # systemd.tmpfiles.rules =
  # let
  #   firmware =
  #     pkgs.runCommandLocal "qemu-firmware" { } ''
  #       mkdir $out
  #       cp ${pkgs.qemu}/share/qemu/firmware/*.json $out
  #       substituteInPlace $out/*.json --replace ${pkgs.qemu} /run/current-system/sw
  #     '';
  # in
  # [ "L+ /var/lib/qemu/firmware - - - - ${firmware}" ];

  # Add firewall exception for VirtualBox provider
  # networking.firewall.extraCommands = ''
  #   ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  #   ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 33306 -j ACCEPT
  # '';

  # Add firewall exception for libvirt provider when using NFSv4
  # networking.firewall.interfaces."virbr1" = {
  #   allowedTCPPorts = [
  #     2049
  #     33306
  #   ];
  #   allowedUDPPorts = [
  #     2049
  #     33306
  #   ];
  # };

  #services.samba = {
  #  enable = true;
  #  securityType = "user";
  #  openFirewall = true;
  #  settings = {
  #    global = {
  #      "workgroup" = "WORKGROUP";
  #      "server string" = "spectre";
  #      "netbios name" = "spectre";
  #      "security" = "user";
  #      #"use sendfile" = "yes";
  #      #"max protocol" = "smb2";
  #      # note: localhost is the ipv6 localhost ::1
  #      "hosts allow" = "192.168.0. 127.0.0.1 localhost";
  #      "hosts deny" = "0.0.0.0/0";
  #      "guest account" = "nobody";
  #      "map to guest" = "bad user";
  #    };
  #    "public" = {
  #    };
  #    "private" = {
  #      "path" = "/mnt/Shares/Private";
  #      "browseable" = "yes";
  #      "read only" = "no";
  #      "guest ok" = "no";
  #      "create mask" = "0644";
  #      "directory mask" = "0755";
  #      "force user" = "kostas";
  #    };
  #  };
  #};

  #services.samba-wsdd = {
  #  enable = true;
  #  openFirewall = true;
  #};

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.checkReversePath = false;
}

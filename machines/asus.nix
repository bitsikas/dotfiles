{
  lib,
  config,
  pkgs,
  nixpkgs-unstable,
  inputs,
  ...
}: {
  imports = [./hardware/asus.nix];

  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixVersions.stable; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # this takes a lot of time sometimes
  documentation.man.generateCaches = false;
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  environment.pathsToLink = ["/libexec"];

  programs.fish.enable = true;
  fonts.fontconfig.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif"];
    sansSerif = ["Noto Sans"];
    monospace = ["FiraCode"];
  };

  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    jetbrains-mono
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    ubuntu-classic
    cantarell-fonts
    roboto
    roboto-serif
  ];

  environment.sessionVariables = {
    # QT_QPA_PLATFORM = "wayland-egl";
    QT_QPA_PLATFORM = "wayland";
    KWIN_IM_SHOW_ALWAYS = "1";
  };
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  services.fwupd.enable = true;
  services.pulseaudio.enable = false;
  services.printing.enable = true;
  services.resolved.enable = true;
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
    dconf
    fd
    ffmpeg
    firefox
    ghostty
    gimp
    gnome-tweaks
    gnomeExtensions.tailscale-qs
    gnomeExtensions.user-themes
    imv
    inetutils
    inkscape
    libreoffice
    nix-index
    pavucontrol
    qt5.qtwayland
    sof-firmware
    thunderbird
    vanilla-dmz
    vlc
    wl-clipboard
    blender
    freecad
    bottles
    bambu-studio
    prusa-slicer
    super-slicer
    orca-slicer
    libreoffice
  ];
  programs.light.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs.gtk3
      pkgs.cairo
      pkgs.pango
      pkgs.harfbuzz
      pkgs.atk
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.libepoxy
      pkgs.fontconfig
    ];
  };
  programs.kdeconnect.enable = false;
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/kssaskpass";
  # programs.kdeconnect.package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
  security.rtkit.enable = true;
  security.sudo.enable = true;

  networking.nftables.enable = true;
  networking.firewall.allowedTCPPorts = [22 80 8080 8551];
  networking.firewall.allowedUDPPorts = [22 config.services.tailscale.port];
  networking.firewall.trustedInterfaces = ["tailscale0"];
  # networking.hosts = {
  #   "127.0.0.1" = ["art.spectre.local" "fit.spectre.local" "miliacafe.spectre.local" "artframe.spectre.local"];
  #   "100.64.0.1" = ["cockpit.bitsikas.home"];
  # };
  # networking.firewall.allowedUDPPorts = [];
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
  # };

  # services.miliacaffe.enable = true;
  # services.miliacaffe.hostnames = ["miliacafe.spectre.local"];

  # services.liverecord.enable = true;
  # services.liverecord.hostnames = ["liverecord.spectre.local"];

  # services.arthome.enable = true;
  # services.arthome.debug = "1";
  # services.arthome.hostnames = ["artframe.spectre.local"];

  # services.fittrack.enable = true;
  # services.fittrack.hostnames = ["fit.spectre.local"];

  # services.ihasb33r.enable = true;
  # services.ihasb33r.hostnames = ["art.spectre.local"];

  # services.mullvad-vpn.enable = true;
  # services.blueman.enable = true;
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
  virtualisation.docker.enable = false;
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  system.stateVersion = "21.11";
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
  # networking.firewall.checkReversePath = false;

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      settings = {
        logtail.enabled = false;
        server_url = "https://ihasb33r.duckdns.org";

        dns = {base_domain = "ihasb33r.duckdns.org";};
      };
    };

    nginx.virtualHosts."ihasb33r.duckdns.org" = {
      forceSSL = false;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.headscale.port}";
        proxyWebsockets = true;
      };
    };
  };
  programs.command-not-found.enable = false;
  # for home-manager, use programs.bash.initExtra instead
  # programs.bash.interactiveShellInit = ''
  #   source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  # '';

  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enableFishIntegration = true;
  # networking.firewall.checkReversePath = "loose"
}

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
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["all"];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;

  environment.sessionVariables = {
    # QT_QPA_PLATFORM = "wayland-egl";
    KWIN_IM_SHOW_ALWAYS = "1";

    # Force Firefox to use Wayland
    MOZ_ENABLE_WAYLAND = "1";

    # Force Qt apps to use Wayland and the IBus input module
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_IM_MODULE = "ibus";
  };
  networking.networkmanager.enable = true;
  services.pcscd.enable = true;
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
    # gnome-boxes
    # inputs.ghostty.packages.x86_64-linux.default
    _1password-cli
    bat
    bottles
    chiaki-ng
    cifs-utils
    coreutils
    dconf
    fd
    ffmpeg
    firefox
    gimp
    gnome-tweaks
    gnomeExtensions.tailscale-qs
    gnomeExtensions.user-themes
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    headscale
    imv
    inetutils
    inkscape
    krita
    kubectl
    libinput-gestures
    libreoffice
    libwacom
    mangal
    minikube
    mypaint
    nix-index
    nixpkgs-unstable.ghostty
    pavucontrol
    qt5.qtwayland
    qt5.qtwayland
    qt6.qtwayland
    skaffold
    sof-firmware
    thunderbird
    transmission-remote-gtk
    vanilla-dmz
    vlc
    wireguard-tools
    wl-clipboard
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

      pkgs.gst_all_1.gstreamer
      # Common plugins like "filesrc" to combine within e.g. gst-launch
      pkgs.gst_all_1.gst-plugins-base
      # Specialized plugins separated by quality
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      # Plugins to reuse ffmpeg to play almost every video format
      pkgs.gst_all_1.gst-libav
      # Support the Video Audio (Hardware) Acceleration API
      pkgs.gst_all_1.gst-vaapi
    ];
  };
  programs.kdeconnect.enable = true;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.plasma5Packages.ksshaskpass.out}/bin/kssaskpass";
  programs.kdeconnect.package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
  security.rtkit.enable = true;
  security.sudo.enable = true;

  programs.firefox.nativeMessagingHosts.euwebid = true;
  programs.firefox.nativeMessagingHosts.packages = [pkgs.web-eid-app];
  programs.firefox.policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
  networking.nftables.enable = true;
  networking.firewall.allowedTCPPorts = [80 8080 8551 47984 47989 47990 48010];
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 47998;
      to = 48000;
    }
    {
      from = 8000;
      to = 8010;
    }
  ];
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.hosts = {
    "127.0.0.1" = ["art.spectre.local" "fit.spectre.local" "miliacafe.spectre.local" "artframe.spectre.local" "liverecord.spectre.local"];
    "100.64.0.1" = ["cockpit.bitsikas.home"];
  };
  # networking.firewall.allowedUDPPorts = [];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings.port = 47989;
    settings.file_apps = "/var/lib/sunshine-apps.json";
    # applications.apps = [];
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
  services.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
    gdm.debug = false;
  };

  services.desktopManager = {
    gnome.enable = true;
    plasma6.enable = true;
    gnome.debug = false;
  };
  # wacom.enable = true;
  #  services.displayManager.ly.enable = true;

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
  # networking.firewall.checkReversePath = false;

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";

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

  environment.pathsToLink = ["/libexec"];

  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
  boot.kernel.sysctl."vm.swappiness" = 10;
}

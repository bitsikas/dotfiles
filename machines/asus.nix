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
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  # programs.kdeconnect.package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
  security.rtkit.enable = true;
  security.sudo.enable = true;

  networking.nftables.enable = true;
  networking.firewall.allowedTCPPorts = [22 80 8080 8551];
  networking.firewall.allowedUDPPorts = [22 config.services.tailscale.port];
  networking.firewall.trustedInterfaces = ["tailscale0"];

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
  };

  services.desktopManager.plasma6.enable = true;

  services.displayManager = {
    defaultSession = "gnome";
  };
  virtualisation.docker.enable = false;
  system.stateVersion = "21.11";

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

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

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;

  nix = {
    autoOptimiseStore = true;
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  users.users.kostas = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/kostas";
    createHome = true;
    description = "Kostas Papakonstantinou";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "bluetooth"
      "libvirtd"
      "vboxusers"
      "video"
      "adbusers"
    ];
    shell = pkgs.fish;
  };

  environment.pathsToLink = [ "/libexec" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    busybox
    bat
    cifs-utils
    fd
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect
    lazygit
    libinput-gestures
    libwacom
    papirus-icon-theme
    pavucontrol
    sof-firmware
    wireguard-tools
    docker-compose

    (
      let 
        pname = "krita";
        version = "5.1.3";
        src = fetchurl {
          url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}-x86_64.appimage";
          sha256 = "b421a12fcd21c5ad18d91c917a9bb82e81b8d8c64c7402e4de3e5c3b5c0f7a67";
        };
        appimageContents = appimageTools.extractType2 { inherit pname version src; };
      in
      appimageTools.wrapType2 { # or wrapType1
      inherit pname version src;
      extraPkgs = pkgs: with pkgs; [ ];
      extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}
      install -m 444 -D ${appimageContents}/org.kde.krita.desktop $out/share/applications/krita.desktop
      install -m 444 -D ${appimageContents}/krita.png $out/share/icons/krita.png
      '';
      meta = with lib; {
        platforms = ["x86_64-linux"];

      };
    }
    )




  ];

  programs.adb.enable = true;
  #programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };
  programs.light.enable = true;
  programs.steam.enable = true;

  fonts.fontconfig.enable = true;
  fonts.enableDefaultFonts = true;
  fonts.fontconfig.defaultFonts = {
    serif = [ "Ubuntu" ];
    sansSerif = [ "Ubuntu" ];
    monospace = [ "Hack" ];
  };

  fonts.fonts = with pkgs; [
    fira-code
    dina-font
    fira-code
    fira-code-symbols
    font-awesome
    hack-font
    liberation_ttf
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
    roboto
    ubuntu_font_family
    google-fonts
  ];

  security.rtkit.enable = true;

  # List services that you want to enable:

  services.mullvad-vpn.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.blueman.enable = true;

  services.dbus = {
    enable = true;
    packages = with pkgs; [ pkgs.dconf ];
  };

  services.gvfs.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.xserver = {
    enable = true;
    libinput = { enable = true; };
    displayManager = {
      lightdm.enable = false;
      gdm.enable = true;
    };
    desktopManager = { gnome.enable = true; };
    modules = [ pkgs.xf86_input_wacom ];
    useGlamor = true;
    videoDrivers = [ "modesetting" ];
    wacom.enable = true;
  };

  #
  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  system.stateVersion = "22.05";

}


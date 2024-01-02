# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "nodejs-16.20.2"
              ];
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland-egl";

  };
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
      "qemu-libvirt"
      "video"
      "adbusers"
    ];
    shell = pkgs.fish;
  };

  environment.pathsToLink = [ "/libexec" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # busybox
    # procps
    coreutils
    bat
    cifs-utils
    fd
    _1password
    #_1password-gui
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect
    # gnomeExtensions.media-controls
    k3s
    lazygit
    libinput-gestures
    libwacom
    papirus-icon-theme
    pavucontrol
    sof-firmware
    wireguard-tools
    docker-compose
    qt5.qtwayland


  ];

  programs.adb.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };
  programs.light.enable = true;
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  # programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

  fonts.fontconfig.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.defaultFonts = {
    serif = [ "Ubuntu" ];
    sansSerif = [ "Ubuntu" ];
    monospace = [ "Hack" ];
  };

  fonts.packages = with pkgs; [
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
    # google-fonts
  ];

  security.rtkit.enable = true;

  # List services that you want to enable:

    networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];

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
  services.printing.drivers = [
    pkgs.cnijfilter2
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.hplip

  ];

  services.xserver = {
    enable = true;
    # libinput = { enable = true; };
    displayManager = {
      lightdm.enable = false;
      # sddm.enable = true;
      gdm.enable = true;
      gdm.wayland = true;
      defaultSession = "gnome";

    };
    desktopManager = { gnome.enable = true; plasma5.enable = true; };
    # modules = [ pkgs.xf86_input_wacom ];
    # videoDrivers = [ "modesetting" ];
    
    wacom.enable = true;
  };

  #
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation.podman.enable = true;
  system.stateVersion = "22.05";
  services.nfs.server.enable = true;
  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = [ "kostas" ];
    # Minimal configuration for NFS support with Vagrant.
  
  # Add firewall exception for VirtualBox provider 
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 33306 -j ACCEPT
  '';

  # Add firewall exception for libvirt provider when using NFSv4 
  networking.firewall.interfaces."virbr1" = {                                   
    allowedTCPPorts = [ 2049 33306 ];
    allowedUDPPorts = [ 2049 33306 ];
  };

}

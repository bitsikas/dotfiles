{ config, pkgs, nixpkgs-unstable, ... }:
{
  imports = [
    ./hardware/spectre.nix
  ];

  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland-egl";
  };
  networking.networkmanager.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.cnijfilter2 
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.hplip
  ];
  environment.systemPackages = with pkgs; [
    _1password
    bat
    calibre
    cifs-utils
    coreutils
    fd
    ffmpeg
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect
    lazygit
    libinput-gestures
    libwacom
    mangal
    papirus-icon-theme
    pavucontrol
    qt5.qtwayland
    sof-firmware
    transmission-remote-gtk
    wireguard-tools
  ];
  programs.light.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  security.rtkit.enable = true;

  networking.firewall.allowedTCPPorts = [
    8000
  ];
  networking.firewall.allowedUDPPorts = [
  ];
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
    packages = with pkgs; [ pkgs.dconf ];
  };
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.avahi= {
    publish = {
      enable=true;
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
    };
    desktopManager = { gnome.enable = true; plasma5.enable = false; };
    wacom.enable = true;
  };
  services.displayManager = {
    defaultSession = "gnome";
  };
  virtualisation.podman.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  system.stateVersion = "22.05";
  
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


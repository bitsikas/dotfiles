# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let

  rawkeys = builtins.readFile (builtins.fetchurl {
    url = "https://github.com/bitsikas.keys";
    sha256 = "1rbxms3pv6msfyhds2bc0haza34fhvy3ya9qj5k30i11xd8sapmv";
  });
  listkeys = lib.strings.splitString "\n" rawkeys;
  goodlistkeys = builtins.filter (x: x != "") listkeys;
in{

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kostas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys =  goodlistkeys ; 

  };
  users.users.root = {
    openssh.authorizedKeys.keys =  goodlistkeys ; 

  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    mullvad
    yt-dlp
    sqlite
  ];
  services.prowlarr={
    enable = true;
    openFirewall = true;
    # dataDir = "/mnt/services/Prowlarr";
      
  };
  services.jellyfin={
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/jellyfin";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/sonarr";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/radarr";
  };
  services.readarr = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/readarr";
  };

  services.transmission = { 
    enable = true; #Enable transmission daemon
    openRPCPort = true; #Open firewall for RPC
    settings = { #Override default settings
    download-dir = "/mnt/Downloads";
    rpc-bind-address = "0.0.0.0"; #Bind to own IP
    rpc-whitelist = "127.0.0.1,192.168.*.*"; #Whitelist your remote machine (10.0.0.1 in this example)
    };
    };

}


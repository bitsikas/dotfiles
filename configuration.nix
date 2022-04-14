# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let 
  unstable = import <nixpkgs-unstable> {};
in {
  imports =
    [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    #wireguard/wireguard.nix
    <home-manager/nixos>
  ];

  services.xserver.modules = [ pkgs.xf86_input_wacom ];
  services.xserver.wacom.enable = true;
  # Enable OpenTabletDriver
  hardware.opentabletdriver.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";



  hardware.bluetooth.enable = true;
  hardware.opengl = {
    enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  users.users.kostas = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/kostas";
    createHome=true;
    description = "Kostas Papakonstantinou";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "bluetooth" "libvirtd" "vboxusers" "video"];
    shell = pkgs.fish;
  };
  home-manager.users.kostas = (import ./kostas.nix);

  environment.pathsToLink = [ "/libexec" ];



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    cifs-utils
    fd
    lazygit
    libinput-gestures
    papirus-icon-theme
    pavucontrol
    wireguard
    #vscode
    libwacom
    (
      pkgs.writeShellApplication {
        name = "virt-keyboard-toggle";
        runtimeInputs = [ squeekboard ];
        text = ''
          visible=$(busctl get-property --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible);
          if [ "$visible" == "b true" ]; then
            busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
          else
            busctl call --user sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
          fi

        '';
      }
      )
    ];


    nixpkgs.config.allowUnfree = true;


services.xserver = {
  enable = false;
  libinput = {
    enable = true;
  };
};

  programs.fish.enable = true ;
  programs.kdeconnect.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };


  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
    hack-font
    mplus-outline-fonts
    roboto
    ubuntu_font_family
  ];

  # List services that you want to enable:

  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.printing.enable = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  services.dbus.enable = true;

  programs.light.enable = true;
  programs.steam.enable = true;
}


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
    <home-manager/nixos>
    # ../../sway/sway.nix
    # ../../waybar/waybar.nix
    # ../../wofi/wofi.nix
    #../../kitty/kitty.nix
    # ../../fish/fish.nix
  ];

  services.xserver.modules = [ pkgs.xf86_input_wacom ];
  services.xserver.wacom.enable = true;
    # Enable OpenTabletDriver
    hardware.opentabletdriver.enable = false;



    # nixpkgs.overlays = [
    #   (self: super: {
    #     mypaint = super.mypaint.overrideAttrs (oldAttrs: {
    #       version = "2.0.1";
    #       src = super.fetchFromGitHub {
    #         owner = "bitsikas";
    #         repo = "mypaint";
    #         rev = "880b08a1afdea935b4f936066eeaefa6f30d2b91";
    #         sha256 = "1civiyzpisqbvpg3da9qx2043jcnkkg7vqxdi1whdrqbz1dxp58v";
    #         fetchSubmodules = true;
    #       };
    #     }
    #     );
    #   }
    #   )
    # ];
    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.pulseaudio.enable = true;

  #security.rtkit.enable = true;
#services.pipewire = {
#  enable = true;
#  alsa.enable = true;
#  alsa.support32Bit = true;
#  pulse.enable = true;
#  # If you want to use JACK applications, uncomment this
#  #jack.enable = true;

#  # use the example session manager (no others are packaged yet so this is enabled by default,
#  # no need to redefine it in your config for now)
#  #media-session.enable = true;
#};
hardware.bluetooth.enable = true;
#  nixpkgs.config.packageOverrides = pkgs: {
#    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
#  };
hardware.opengl = {
  enable = true;
#    extraPackages = with pkgs; [
#      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
#      vaapiVdpau
#      libvdpau-va-gl
#    ];
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
  home-manager.users.kostas = (import ./home.nix);

  environment.variables.EDITOR = "nvim";
  environment.pathsToLink = [ "/libexec" ];
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; 
  };
  environment.etc = {
     #"xdg/gtk-2.0".source = ./gtk-2.0;
     #"xdg/gtk-3.0".source = ./gtk-3.0;
   };
  # environment.loginShellInit = ''
  #   if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  #     dbus-run-session sway
  #   fi
  # '';


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    chromium
    cifs-utils
    direnv
    dconf
    exa
    fd
    firefox-wayland
    fzf
    gcc
    gh
    gimp
    gnumake
    go
    gopls
    gparted
    htop
    httpie
    imv
    inkscape
    #kitty
    lastpass-cli
    lazygit
    libinput-gestures
    lxappearance
    #neovim 
    rnix-lsp
    nodejs
    nordic
    papirus-icon-theme
    pavucontrol
    pipenv
    python39
    python39Packages.poetry
    ranger
    ripgrep
    rq
    stow
    tmux
    unrar
    vlc
    #vscode
    wget
    zathura
    libwacom
    unstable.krita
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

  #nixpkgs.overlays = [(self: super: {
#	  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
#
#	    version = "0.6.0";
#
#	    src = pkgs.fetchFromGitHub {
#	      owner = "neovim";
#	      repo = "neovim";
#	      rev = "v0.6.0";
#	      sha256 = "sha256-mVVZiDjAsAs4PgC8lHf0Ro1uKJ4OKonoPtF59eUd888=";
#	    };
#
#            nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter ];
#	  });
#	})];

services.xserver = {
  enable = false;
  libinput = {
    enable = true;
  };
};
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  programs.fish.enable = true ;
  programs.light.enable = true;
  programs.kdeconnect.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  programs.steam.enable = true;

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

  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  virtualisation.docker.enable = true;
#  virtualisation.virtualbox.host.enable = true;
#  virtualisation.libvirtd.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  services.dbus.enable = true;

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
}


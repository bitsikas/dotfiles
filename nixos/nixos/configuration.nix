# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";


  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.printing.enable = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.default = lib.mkForce "sway";
  services.xserver.displayManager.defaultSession = "sway";

  # Configure keymap in X11
  services.xserver.layout = "us,gr";
  # services.xserver.xkbOptions = "eurosign:e";

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kostas = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/kostas";
    description = "Kostas Papakonstantinou";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "bluetooth"];
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    chromium
    cifs-utils
    exa
    fd
    firefox
    fzf
    gcc
    gh
    gimp
    git
    gnumake
    go
    gopls
    gparted
    htop
    httpie
    inkscape
    kitty
    lastpass-cli
    lazygit
    neovim 
    nodejs
    pavucontrol
    pipenv
    python39
    ranger
    ripgrep
    rq
    stow
    tmux
    vlc
    vscode
    wget
  ];

  environment.variables.EDITOR = "nvim";
  environment.pathsToLink = [ "/libexec" ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [(self: super: {
	  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {

	    version = "0.6.0";

	    src = pkgs.fetchFromGitHub {
	      owner = "neovim";
	      repo = "neovim";
	      rev = "v0.6.0";
	      sha256 = "sha256-mVVZiDjAsAs4PgC8lHf0Ro1uKJ4OKonoPtF59eUd888=";
	    };

            nativeBuildInputs = super.neovim-unwrapped.nativeBuildInputs ++ [ super.tree-sitter ];
	  });
	})];

  programs.fish.enable = true ;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  programs.steam.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      libappindicator-gtk2
      libappindicator-gtk3
      libnotify
      mako 
      pamixer
      polkit_gnome
      swayidle
      swaylock
      waybar
      wl-clipboard
      wofi
    ];
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
  security.rtkit.enable = true;

  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #};

  virtualisation.docker.enable = true;

  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  # nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  # 
  services.gvfs.enable = true;

  services.gnome.gnome-keyring.enable = true;
}


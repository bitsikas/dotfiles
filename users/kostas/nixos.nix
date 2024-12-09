# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:

{
  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  users.users.kostas = {
    isNormalUser = true;
    home = "/home/kostas";
    createHome = true;
    description = "Kostas";
    extraGroups = [
      "adbusers"
      "audio"
      "bluetooth"
      "docker"
      "libvirtd"
      "networkmanager"
      "qemu-libvirt"
      "vboxusers"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRASEE/kkq/U/MKRyN+3OTEofM7FgACxLzvuT/NtTWP "
    ];
  };

  environment.pathsToLink = [ "/libexec" ];

  programs.fish.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts.fontconfig.enable = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" ];
    sansSerif = [ "Noto Sans" ];
    monospace = [ "FiraCode" ];
  };

  fonts.packages = with pkgs; [
    fira-code
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ubuntu_font_family
    cantarell-fonts
    roboto
    roboto-serif
  ];

}

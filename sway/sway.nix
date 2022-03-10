{ config, pkgs, ... }:

{
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
      swaybg
      swayidle
      swaylock
      waybar
      wl-clipboard
      wofi
    ];
  };
  environment.etc."sway/config".source = .config/sway/config;
  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      dbus-run-session sway
    fi
  '';
}

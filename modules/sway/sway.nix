{ config, pkgs, lib, ... }:
let
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  customconfig = { wallpaper = "/home/kostas/.wallpaper.jpg"; };
in rec {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      terminal = "kitty";
      modifier = "Mod4";
      keybindings = lib.mkOptionDefault rec {
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift + q" = "kill";
        "${modifier}+d" = "exec wofi -S run";
        "XF86MonBrightnessUp" = ''exec "light -A 5"'';
        "XF86MonBrightnessDown" = ''exec "light -U 5"'';
      };
      bars = [ ];

      input = {
        "type:keyboard" = {
          xkb_layout = "us,gr";
          xkb_options = "grp:alt_shift_toggle";
        };
        "type:touchpad" = { tap = "enabled"; };
      };
      startup = [
        # { command = "${swaylock} -i ${customconfig.wallpaper}"; }
        # { command = "${swaylock} -i ${customconfig.wallpaper}"; }
        { command = "swaybg -i ${customconfig.wallpaper}"; }
        { command = "mako"; }
        { command = "waybar"; }
        {
          command = "flashfocus";
        }
        # { command = "squeekboard" ;}
        { command = "blueman-applet"; }

      ];
    };
    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile .config/sway/config)
      ''
        exec dbus-update-activation-environment WAYLAND_DISPLAY
        exec systemctl --user import-environment WAYLAND_DISPLAY
      ''
    ]);

  };
  home.packages = with pkgs; [
    waybar
    wl-clipboard
    wofi
    libnotify
    mako
    mypaint
    pamixer
    polkit_gnome
    squeekboard
    light
    flashfocus
    swaybg
    swayidle
    swaylock-effects
    libinput-gestures
  ];

  programs.fish.loginShellInit = lib.mkBefore ''
    if test (tty) = /dev/tty1
    #dbus-run-session sway &> /dev/null
    sway &> /dev/null
    end
  '';

}

{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    # theme = "Solarized Dark Higher Contrast";
    # theme = "Solarized Light";
    #extraConfig = (builtins.readFile .config/kitty/theme.conf);
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 14;
    };
    #theme = "Gruvbox_light";
    keybindings = {
      # open new split in current directory
      "ctrl+return" = "launch --location vsplit --cwd=current";
      "ctrl+shift+return" = "launch --location hsplit --cwd=current";
      "super+shift+return" = "launch --location hsplit --cwd=current";
      "super+return" = "launch --location vsplit --cwd=current";
      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";
    };
    darwinLaunchOptions = [
      "--single-instance"
      "--listen-on=unix:/tmp/kitty-kostas-socket"
    ];
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      listen-on = "unix:/tmp/kitty-kostas-socket";
      enabled_layouts = "splits:split_axis=horizontal;bias=50";
      enable_audio_bell = "no";
      allow_remote_control = "yes";
      # background_tint = "0.9";
      window_padding_width = "4";
      background_opacity = "0.9";
      adjust_line_height = "120%";
      include = "current-theme.conf";
      # globinclude  = "kitty.d/**/*.conf";
    };
  };
}

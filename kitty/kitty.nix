{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    # theme = "Solarized Dark Higher Contrast";
    theme = "Solarized Light";
    #extraConfig = (builtins.readFile .config/kitty/theme.conf);
    font = {
      name = "Fira Code";
      size = 11;
    };
    #theme = "Gruvbox_light";
    keybindings = {
      "f5"= "launch --location vsplit";
      "f6"= "launch --location hsplit";
      "ctrl+left"  = "neighboring_window left";
      "ctrl+right" =  "neighboring_window right";
      "ctrl+up"  = "neighboring_window up";
      "ctrl+down"  = "neighboring_window down";
    };
    darwinLaunchOptions = [
  "--single-instance"
  "--directory=/tmp/kitty-kostas"
  "--listen-on=unix:/tmp/kitty-kostas-socket"
];
    settings = {
      enabled_layouts="splits:split_axis=horizontal;bias=50";
      enable_audio_bell = "no";
      allow_remote_control = "yes";
      background_tint = "0.9";
      window_margin_width = "15";
      background_opacity = "1";
      adjust_line_height = "150%";
    };
  };

}

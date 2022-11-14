{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    theme = "Solarized Light";
    #extraConfig = (builtins.readFile .config/kitty/theme.conf);
    font = {
      name = "FiraCode Nerd Font Mono, Fira Code, monospace";
      size = 10;
    };
    #theme = "Gruvbox_light";
    settings = {
      enable_audio_bell = "no";
      allow_remote_control = "yes";
      background_tint = "0.9";
      window_margin_width = "15";
      background_opacity = "1";
      adjust_line_height = "120%";
    };
  };

}


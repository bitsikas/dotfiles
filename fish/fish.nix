{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "exa";
      cat = "bat";
    };
    interactiveShellInit =
      # Use vim bindings and cursors
      ''
        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block
      '';
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
}


{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-command "${pkgs.nushell}/bin/nu"
      set -g mouse  on
      set-window-option -g mode-keys vi
    '';
    plugins = [
      pkgs.tmuxPlugins.sensible
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'frappe'";
      }
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          set -g @vim_navigator_mapping_left "Super_L-Left Super_L-h"  # use Super_L-h and Super_L-Left
          set -g @vim_navigator_mapping_right "Super_L-Right Super_L-l"
          set -g @vim_navigator_mapping_up "Super_L-k"
          set -g @vim_navigator_mapping_down "Super_L-j"
        '';
      }
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.tilish;
        extraConfig = ''
          set -g @tilish-navigator 'on'
          set -g mode-keys vi

          # Natural scroll, line by line.
          bind-key -T copy-mode-vi WheelUpPane   send-keys -X scroll-down-and-cancel
          bind-key -T copy-mode-vi WheelDownPane send-keys -X scroll-up

          # Don't overwrite scroll for tools that already know about it.
          bind-key -n WheelDownPane if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" "send -M" "copy-mode -e"


          # Use v to trigger selection
          bind-key -T copy-mode-vi v send-keys -X begin-selection

          # Use y to yank current selection
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel


        '';
      }
    ];
  };
}

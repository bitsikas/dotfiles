{pkgs, ...}:
{

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse  on 
    '';
    plugins = [
      pkgs.tmuxPlugins.sensible
      {
        plugin= pkgs.tmuxPlugins.catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'frappe'";
      }
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.tilish;
        extraConfig = "set -g @tilish-navigator 'on'";
      }
    ];

  };
}

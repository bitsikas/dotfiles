{pkgs, ...}:
{

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse  on 
    '';
    plugins = [
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.nord
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.tilish;
        extraConfig = "set -g @tilish-navigator 'on'";
      }
    ];

  };
}

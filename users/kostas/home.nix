{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "kostas";
  home.homeDirectory = "/home/kostas";
  home.stateVersion = "21.11";
  home.sessionVariables = {
    "EDITOR" = "nvim";
  };
  imports = [
    ../../modules/desktop.nix
    ../../modules/cli.nix
    ../../modules/linux.nix
  ];
  home.file."${config.xdg.configHome}/ghostty/config".text = ''
    theme = Catppuccin Frappe
    shell-integration-features = sudo,title,ssh-env,ssh-terminfo
    command = ${pkgs.fish}/bin/fish

    keybind = ctrl+h=goto_split:left
    keybind = ctrl+j=goto_split:bottom
    keybind = ctrl+k=goto_split:top
    keybind = ctrl+l=goto_split:right

    keybind = ctrl+a>shift+5=new_split:right
    keybind = ctrl+a>shift+'=new_split:down
    keybind = ctrl+a>z=toggle_split_zoom

    keybind = ctrl+a>n=next_tab
    keybind = ctrl+a>p=previous_tab

    window-save-state = always

  '';
}

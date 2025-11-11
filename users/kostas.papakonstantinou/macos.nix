{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    reattach-to-user-namespace
    nerd-fonts.fira-code
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
  # programs.kitty.settings.text_composition_strategy = "4 30";
  # imports = [../../modules/kitty/kitty.nix];
}

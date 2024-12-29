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
    theme = catppuccin-frappe
  '';
}

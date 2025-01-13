{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    reattach-to-user-namespace
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];
  home.file."${config.xdg.configHome}/ghostty/config".text = ''
    theme = catppuccin-frappe
    command = ${pkgs.fish}/bin/fish
  '';
  # programs.kitty.settings.text_composition_strategy = "4 30";
  imports = [../../modules/kitty/kitty.nix];
}

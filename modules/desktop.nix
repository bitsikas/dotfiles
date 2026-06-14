{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}: {
  imports = [
    # sway/sway.nix
    # wofi/wofi.nix
    # mako/mako.nix
    # waybar/waybar.nix
    # ./kitty/kitty.nix
  ];

  home.packages = with pkgs; [];
}

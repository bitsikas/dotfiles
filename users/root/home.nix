{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  home.stateVersion = "21.11";
  imports = [
    ../../modules/cli.nix
    ../../modules/linux.nix
  ];
}

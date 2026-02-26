{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}: {
  options = {
    myFeatures.desktop = lib.mkEnableOption "desktop GUI applications";
  };
}

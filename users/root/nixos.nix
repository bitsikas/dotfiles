{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}: {
  users.users.root.shell = pkgs.fish;
}

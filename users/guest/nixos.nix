{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}: {
  users.users.guest = {
    isNormalUser = true;
    home = "/home/guest";
    description = "Some guest";
    extraGroups = ["wheel" "networkmanager"];
  };
}

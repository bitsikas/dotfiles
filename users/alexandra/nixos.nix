{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}: {
  users.users.alexandra = {
    isNormalUser = true;
    home = "/home/alexandra";
    description = "Alexandra";
    extraGroups = ["networkmanager" "video" "audio" "bluetooth"];
  };
}

{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  inputs,
}: user: {
  system,
  darwin ? false,
}: let
  homedir =
    if darwin
    then "/Users/${user}/"
    else "/home/${user}/";
  platform =
    if darwin
    then "macos"
    else "linux";
  platformConfig = ../users/${user}/${platform}.nix;
  homeFunc = home-manager.lib.homeManagerConfiguration;
in
  homeFunc rec {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      {
        home.username = user;
        home.homeDirectory = homedir;
        # home.sessionVariables = {
        # };
        home.sessionVariables = {
          "EDITOR" = "nvim";
          "TERMINAL" = "ghostty";
          GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
            pkgs.gst_all_1.gst-plugins-base
            pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
            pkgs.gst_all_1.gst-plugins-good
            pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
            pkgs.gst_all_1.gst-plugins-bad
            pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
            pkgs.gst_all_1.gst-plugins-ugly
            pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
            pkgs.gst_all_1.gst-libav
            pkgs.pkgsi686Linux.gst_all_1.gst-libav
            pkgs.gst_all_1.gst-vaapi
            pkgs.pkgsi686Linux.gst_all_1.gst-vaapi
          ];
        };
      }
      {fonts.fontconfig.enable = true;}
      {programs.home-manager.enable = true;}
      {nixpkgs.config.allowUnfree = true;}
      {
        nixpkgs.overlays = [
          inputs.neorg-overlay.overlays.default
        ];
      }

      {
        nixpkgs.config.permittedInsecurePackages = [
          "nodejs-16.20.0"
          "nodejs-16.20.2"
        ];
      }
      platformConfig
      {home.stateVersion = "23.05";}
      ../modules/cli.nix
      (
        {pkgs, ...}: rec {
          _module.args.nixpkgs-unstable = import nixpkgs-unstable {inherit system;};
        }
      )
    ];
  }

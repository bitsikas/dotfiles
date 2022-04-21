{ config, pkgs, lib, ... }:
let 
  unstable = import <nixpkgs-unstable> {};
in rec {
  imports = [
    sway/sway.nix
    wofi/wofi.nix
    waybar/waybar.nix
    foot/foot.nix
    kitty/kitty.nix
  ];



  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  home.packages = [
    pkgs.firefox-wayland
    pkgs.chromium
    pkgs.gimp
    pkgs.dconf
    pkgs.inkscape
    pkgs.zathura
    unstable.krita
    pkgs.google-chrome
    pkgs.imv
  ];
  nixpkgs.overlays = [
    (
      self: super: {
        mypaint = super.mypaint.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            (super.fetchpatch {
              url = "https://github.com/bitsikas/mypaint/commit/7999c657cb62e2085d48f2e93f667f83c954443e.patch";
              sha256 = "1rqg98zl29cqr9jwqfm6i06sfz53valb5n0n34624qssmyby0kqc";
            })
          ];
        });
      }
      )

    ];

}


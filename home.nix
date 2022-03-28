{ config, pkgs, lib, ... }:
let 
  unstable = import <nixpkgs-unstable> {};
in rec {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kostas";
  home.homeDirectory = "/home/kostas";

  imports = [
    sway/sway.nix
    fish/fish.nix
    nvim/nvim.nix
    kitty/kitty.nix
    git/git.nix
    waybar/waybar.nix
  ];
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.bat.enable = true;
  programs.gh.enable = true;
  programs.direnv.enable = true;


  xdg.configFile."wofi/config".text = ''
      image_size=32
      columns=1
      allow_images=true
      insensitive=true

      run-always_parse_args=true
      run-cache_file=/dev/null
      run-exec_search=true
  '';

  xdg.configFile."wofi/style.css".text =(builtins.readFile wofi/.config/wofi/style.css);

  home.packages = with pkgs; [
    nordic
    visidata
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

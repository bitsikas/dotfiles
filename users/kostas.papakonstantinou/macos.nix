{pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    reattach-to-user-namespace
    (
      nerdfonts.override {
        fonts = [ "FiraCode" ];
      }
      )

  ];
  programs.kitty.settings.text_composition_strategy = "4 30";
  imports = [ ../../kitty/kitty.nix ];
}

{
  builtins,
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

  home.packages = with pkgs; [
    # (
    #   let
    #     pname = "krita";
    #     version = "6.0.0";
    #     src = fetchurl {
    #       url = "https://download.kde.org/stable/krita/6.0.0/krita-6.0.0-x86_64.AppImage";
    #       hash = "sha256-XWgt7m9XpjmzqVu5ub7CC7FwLUGhvMPkxmFTJvVlsiE=";
    #       # url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}-x86_64.appimage";
    #       # sha256 = "b421a12fcd21c5ad18d91c917a9bb82e81b8d8c64c7402e4de3e5c3b5c0f7a67";
    #     };
    #     appimageContents = appimageTools.extractType2 {inherit pname version src;};
    #   in
    #     appimageTools.wrapType2 {
    #       # or wrapType1
    #       inherit pname version src;
    #       # extraPkgs = pkgs: with pkgs; [];
    #       extraPkgs = pkgs:
    #         with pkgs; [
    #           fontconfig
    #           freetype
    #           dejavu_fonts
    #           noto-fonts
    #           liberation_ttf
    #           libGL
    #           mesa
    #           libglvnd
    #           expat
    #         ];
    #       postInstall = ''
    #         wrapProgram $out/bin/krita \
    #           --set FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf \
    #           --set FONTCONFIG_PATH ${pkgs.fontconfig.out}/etc/fonts \
    #           --set XDG_DATA_DIRS $XDG_DATA_DIRS:${pkgs.fontconfig.out}/share \
    #           --set QT_QPA_PLATFORM "wayland;xcb"
    #       '';
    #       extraInstallCommands = ''
    #         install -m 444 -D ${appimageContents}/org.kde.krita.desktop $out/share/applications/krita.desktop
    #         install -m 444 -D ${appimageContents}/krita.png $out/share/icons/krita.png
    #         substituteInPlace $out/share/applications/krita.desktop \
    #           --replace Exec=krita Exec="env FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts XDG_DATA_DIRS=$XDG_DATA_DIRS:${pkgs.fontconfig.out}/share QT_QPA_PLATFORM=wayland;xcb krita"
    #       '';
    #       meta = with lib; {
    #         platforms = ["x86_64-linux"];
    #       };
    #     }
    # )
  ];
  # gtk = {
  #   enable = true;
  #   font = {
  #     name = "Ubuntu";
  #     size = 10;
  #   };
  #   # theme.name = "gruvbox";
  #   # theme.package = pkgs.gruvbox-dark-gtk;
  # };
  # qt = {
  #   enable = true;
  #   # platformTheme = "gnome";
  #   # style.name = "gruvbox";
  #   # style.package = pkgs.kde-gruvbox;
  # };
  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode.fhs;
  # };
}

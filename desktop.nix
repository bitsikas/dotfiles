{ builtins, config, pkgs, lib, nixpkgs-unstable, ... }: {
  imports = [
    sway/sway.nix
    wofi/wofi.nix
    mako/mako.nix
    waybar/waybar.nix
    kitty/kitty.nix
  ];

  nixpkgs.config.chromium.commandLineArgs =
    "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  home.packages = with pkgs; [
    firefox-wayland
    chromium
    gimp
    dconf
    inkscape
    zathura
    google-chrome
    imv
    hack-font
    vlc
    krita
    libreoffice
    mypaint


    # (
    #   let 
    #     pname = "krita";
    #     version = "5.1.3";
    #     src = fetchurl {
    #       url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}-x86_64.appimage";
    #       sha256 = "b421a12fcd21c5ad18d91c917a9bb82e81b8d8c64c7402e4de3e5c3b5c0f7a67";
    #     };
    #     appimageContents = appimageTools.extractType2 { inherit pname version src; };
    #   in
    #   appimageTools.wrapType2 { # or wrapType1
    #   inherit pname version src;
    #   extraPkgs = pkgs: with pkgs; [ ];
    #   extraInstallCommands = ''
    #   mv $out/bin/${pname}-${version} $out/bin/${pname}
    #   install -m 444 -D ${appimageContents}/org.kde.krita.desktop $out/share/applications/krita.desktop
    #   install -m 444 -D ${appimageContents}/krita.png $out/share/icons/krita.png
    #   '';
    #   meta = with lib; {
    #     platforms = ["x86_64-linux"];

    #   };
    # }
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
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}



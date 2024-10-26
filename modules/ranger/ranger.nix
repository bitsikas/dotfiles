{ config, pkgs, ... }:
{

  # environment.etc."ranger/rc.conf".source = .config/ranger/rc.conf;
  home.file.".config/ranger/rc.conf".source = .config/ranger/rc.conf;
  home.packages = with pkgs; [
    ranger
    highlight
    atool
    mediainfo
    w3m
    ffmpegthumbnailer
    odt2txt
  ];

}

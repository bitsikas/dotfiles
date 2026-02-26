{
  config,
  pkgs,
  lib,
  ...
}: {
  # environment.etc."ranger/rc.conf".source = .config/ranger/rc.conf;
  home.file.".config/ranger/rc.conf".source = .config/ranger/rc.conf;
  home.packages =
    [
    ]
    ++ lib.optionals config.myFeatures.desktop [
      pkgs.ranger
      pkgs.highlight
      pkgs.atool
      pkgs.mediainfo
      pkgs.w3m
      pkgs.ffmpegthumbnailer
      pkgs.odt2txt
    ];
}

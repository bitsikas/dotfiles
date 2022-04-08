{ config, pkgs, ... }:
{

  environment.etc."ranger/rc.conf".source = .config/ranger/rc.conf;
}

{ config, pkgs, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.settings = [
    {
      height=48;
      position="top";

      modules-left = ["custom/virt-key"  "sway/workspaces"  "sway/mode"] ;
      modules-center = ["sway/window"] ;
      modules-right = ["idle_inhibitor"  "pulseaudio"  "network"  "sway/language"  "battery"  "clock"  "tray"] ;
      modules = {
        "custom/virt-key"= {
          format= "";
          on-click= "virt-keyboard-toggle";
        };
        battery = {
          bat = "BAT0";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
      };
    }
  ];
  programs.waybar.style = (builtins.readFile .config/waybar/style.css);
}



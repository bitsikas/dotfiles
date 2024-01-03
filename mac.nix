{pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    # colima
    reattach-to-user-namespace
    fira-code
    fira-code-symbols

  ];
  home.username = "Kostas.Papakon";
  home.stateVersion = "22.05";
  home.homeDirectory = "/Users/Kostas.Papakon";
  nixpkgs.config.permittedInsecurePackages = [
                "nodejs-16.20.0"
                "nodejs-16.20.2"
              ];

  programs.kitty.settings.text_composition_strategy = "4 30";
}

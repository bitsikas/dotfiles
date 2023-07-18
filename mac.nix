{pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    # colima
    reattach-to-user-namespace
      fira-code
      fira-code-symbols

  ];
  home.programs.kitty.settings.text_composition_strategy = "4 30";
}

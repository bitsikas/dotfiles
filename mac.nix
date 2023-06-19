{pkgs, ...}:
{
  home.packages = with pkgs; [
    colima
    reattach-to-user-namespace
      fira-code
      fira-code-symbols

  ];
  


}

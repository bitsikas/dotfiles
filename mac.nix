{pkgs, ...}:
{
  home.packages = with pkgs; [
    reattach-to-user-namespace
      fira-code
      fira-code-symbols

  ];
  


}

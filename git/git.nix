{ config, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "Kostas Papakonstantinou";
    userEmail = "kostas@bitsikas.dev";
    extraConfig = {
      color = { ui = "auto"; };
      feature = { manyFiles = true; };
      core = { fsmonitor = true; };
      push = { default = "simple"; };
      mergetool = {
        tool = "fugitive";
        keepBackup = "false";
        prompt = "false";
      };
      "mergetool \"fugitive\"" = {
        cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';
      };
      difftool = { prompt = "false"; };
      "difftool \"nvimdiff\"" = { cmd = ''nvim -d "$LOCAL" "$REMOTE"''; };
      pull = { ff = "only"; };

      "url \"git@github.com:\"" = { insteadOf = "https://github.com/"; };
    };
  };
}

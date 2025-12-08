{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kostas Papakonstantinou";
        email = "kostas@bitsikas.dev";
      };
      rerere = {
        enabled = true;
      };
      color = {
        ui = "auto";
      };
      feature = {
        manyFiles = true;
        skipHash = true;
      };
      core = {
        fsmonitor = true;
      };
      fsmonitor = {
        socketDir = "~/.fsmonitor";
      };
      push = {
        default = "simple";
      };
      mergetool = {
        tool = "fugitive";
        keepBackup = "false";
        prompt = "false";
      };
      "mergetool \"fugitive\"" = {
        cmd = ''nvim -f -c "Gvdiffsplit!" "$MERGED"'';
      };
      difftool = {
        prompt = "false";
      };
      "difftool \"nvimdiff\"" = {
        cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      };
      pull = {
        ff = "only";
      };

      "url \"git@github.com:\"" = {
        insteadOf = "https://github.com/";
      };
    };
  };
}

{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      alias = {
        files = "!git diff --name-only $(git merge-base HEAD \"$REVIEW_BASE\")";
        stat = "!git diff --stat $(git merge-base HEAD \"$REVIEW_BASE\")";
        review = "!nvim -p $(git files) +\"tabdo Gvdiff $REVIEW_BASE\" +\"let g:gitgutter_diff_base = '$REVIEW_BASE'\"";
        reviewone = "!nvim -p +\"tabdo Gvdiff $REVIEW_BASE\" +\"let g:gitgutter_diff_base = '$REVIEW_BASE'\"";
      };
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

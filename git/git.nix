{ config, pkgs, ... }:
{


  programs.git = {
    enable = true;
    package = pkgs.git.overrideAttrs(
      old: {
        version = "2.37.0";
        src = pkgs.fetchurl {
          url = "https://www.kernel.org/pub/software/scm/git/git-2.37.0.tar.xz";
          sha256 = "9f7fa1711bd00c4ec3dde2fe44407dc13f12e4772b5e3c72a58db4c07495411f";
        };

      }
      );
      userName = "Kostas Papakonstantinou";
      userEmail = "kostas@bitsikas.dev";
      extraConfig = {
        color = {
          ui = "auto";
        };
        core = {
          fsmonitor = true;
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
          cmd = "nvim -f -c \"Gvdiffsplit!\" \"$MERGED\"";
        };
        difftool = {
          prompt = "false";
        };
        "difftool \"nvimdiff\"" = {
          cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
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

{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    # settings = {
    #   add_newline = false;
    #   format = lib.concatStrings [
    #     "$username"
    #     "$hostname"
    #     "$directory"
    #     "$git_branch"
    #     "$git_state"
    #     "$git_status"
    #     "$cmd_duration"
    #     "$line_break"
    #     "$python"
    #     "$character"
    #   ];
    #   directory = { style = "blue"; };

    #   character = {
    #     success_symbol = "[❯](purple)";
    #     error_symbol = "[❯](red)";
    #     vicmd_symbol = "[❮](green)";
    #   };

    #   git_branch = {
    #     format = "[$branch]($style)";
    #     style = "yellow";
    #   };

    #   git_status = {
    #     format =
    #       "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
    #     style = "cyan";
    #     conflicted = "​";
    #     untracked = "​";
    #     modified = "​";
    #     staged = "​";
    #     renamed = "​";
    #     deleted = "​";
    #     stashed = "≡";
    #   };

    #   git_state = {
    #     format = "([$state( $progress_current/$progress_total)]($style)) ";
    #     style = "blue";
    #   };

    #   cmd_duration = {
    #     disabled = true;
    #     format = "[$duration]($style) ";
    #     style = "yellow";
    #   };

    #   python = {
    #     format = "[$virtualenv]($style) ";
    #     style = "green";
    #   };

    # };
  };
}

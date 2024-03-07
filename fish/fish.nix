{ config, pkgs, ... }: {
  programs.fish = {
    enable = true;
    plugins = [{
      name = "foreign-env";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "plugin-foreign-env";
        rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
        sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
      };
    }];

    shellInit = ''
      # nix
         if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daem
         end

      # home-manager
         if test -e /etc/bash.bashrc
          fenv source /etc/bash.bashrc
         end

       if test -e $HOME/.nix-profile/etc/profile.d/nix.fish
          . $HOME/.nix-profile/etc/profile.d/nix.fish
       end
    '';

    shellAbbrs = {
      ls = "eza";
      light_on = "kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Latte";
      light_off = "kitty +kitten themes --config-file-name kitty.d/theme.conf --reload-in=all Catppuccin-Frappe";
      cat = "bat";
      taskell = "taskell ~/taskell.md";
      ssh-add-apple = "ssh-add --apple-use-keychain";
      kssh = "kitty +kitten ssh";
    };
    functions = {
      ssht = "ssh -t \"$argv\" 'tmux new-session -t kostas'";
    };

    interactiveShellInit =
      # Use vim bindings and cursors
      ''
        fish_vi_key_bindings
        set fish_cursor_default     block      blink
        set fish_cursor_insert      line       blink
        set fish_cursor_replace_one underscore blink
        set fish_cursor_visual      block
      '';
  };
}


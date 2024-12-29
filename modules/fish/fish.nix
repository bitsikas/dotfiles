{
  config,
  pkgs,
  ...
}: let
  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
    hash = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
  };
in {
  xdg.configFile."fish/themes/Catppuccin Latte.theme".source = "${catppuccin-fish}/themes/Catppuccin Latte.theme";
  xdg.configFile."fish/themes/Catppuccin Frappe.theme".source = "${catppuccin-fish}/themes/Catppuccin Frappe.theme";
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
    ];

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

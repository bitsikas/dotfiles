{ config, pkgs, lib, ... }:
let 
  unstable = import <nixpkgs-unstable> {};
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  customconfig = {
    wallpaper = "/home/kostas/.wallpaper.jpg";
  };
in rec {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kostas";
  home.homeDirectory = "/home/kostas";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile ../../../nvim/.config/nvim/init.vim)
      (builtins.readFile ../../../nvim/.config/nvim/settings/floatterm.vim)
      (builtins.readFile ../../../nvim/.config/nvim/settings/styling.vim)
      (builtins.readFile ../../../nvim/.config/nvim/settings/telescope.vim)
    ]);    plugins = [
      unstable.vimPlugins.nord-vim 
      unstable.vimPlugins.editorconfig-vim 
      unstable.vimPlugins.gitgutter
      unstable.vimPlugins.nvim-compe
      unstable.vimPlugins.nvim-lspconfig
      unstable.vimPlugins.nvim-lsputils
      unstable.vimPlugins.plenary-nvim 
      unstable.vimPlugins.telescope-nvim 
      unstable.vimPlugins.vim-airline 
      unstable.vimPlugins.vim-airline-themes
      unstable.vimPlugins.vim-commentary
      unstable.vimPlugins.vim-floaterm
      unstable.vimPlugins.vim-fugitive
      unstable.vimPlugins.vim-nix
      unstable.vimPlugins.vim-surround
      unstable.vimPlugins.vimspector
    ];
  };

  programs.git = {
    enable = true;
    userName = "Kostas Papakonstantinou";
    userEmail = "kostas@bitsikas.dev";
    extraConfig = {
      color = {
        ui = "auto";
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

  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "exa";
      cat = "bat";
    };
    loginShellInit = lib.mkBefore ''
      if test (tty) = /dev/tty1
      #dbus-run-session sway &> /dev/null
      sway &> /dev/null
      end
    '';
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
    programs.fzf.enable = true;
    programs.exa.enable = true;
    programs.bat.enable = true;
    programs.gh.enable = true;
    programs.direnv.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      systemdIntegration = true;
      wrapperFeatures.gtk = true;
      config = rec {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault rec {
          "${modifier}+Return" = "exec kitty";
          "${modifier}+Shift + q" = "kill";
          "${modifier}+d" = "exec wofi";
          "${modifier}+1" = "workspace number 1 web";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9 teams";
          "${modifier}+0" = "workspace number 10 slack";
          "${modifier}+Shift+1" = "move container to workspace number 1 web";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9 teams";
          "${modifier}+Shift+0" = "move container to workspace number 10 slack";
          "XF86MonBrightnessUp" = "exec \"light -A 5\"";
          "XF86MonBrightnessDown" = "exec \"light -U 5\"";
        };
        bars = [];

        input = { 
          "type:keyboard"  = {
            xkb_layout = "us,gr";
            xkb_options  = grp:alt_shift_toggle;
          };
        };


        startup = [
          #{ command = "${swaylock} -i ${customconfig.wallpaper}"; }
          # { command = "${swaylock} -i ${customconfig.wallpaper}"; }
          { command = "swaybg -i ${customconfig.wallpaper}"; }
          { command = "mako" ;}
          { command = "waybar" ;}
          { command = "flashfocus" ;}
          { command = "squeekboard" ;}
          { command = "blueman-applet" ;}

        ];
      };
      extraConfig = (builtins.concatStringsSep "\n" [
        (builtins.readFile ../../../sway/.config/sway/config)
        ''
          exec dbus-update-activation-environment WAYLAND_DISPLAY
          exec systemctl --user import-environment WAYLAND_DISPLAY
        ''
      ]);

    };


    home.packages = with pkgs; [
      flashfocus
      libnotify
      light
      mako 
      pamixer
      polkit_gnome
      squeekboard
      swaybg
      swayidle
      swaylock-effects
      visidata
      waybar
      wl-clipboard
      wofi
    ];
    programs.kitty.enable = true;

  }

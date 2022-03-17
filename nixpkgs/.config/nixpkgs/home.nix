{ config, pkgs, ... }:
let 
  unstable = import <nixpkgs-unstable> {};
in {
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
    extraConfig = ''
          (builtins.readFile ../../../nvim/.config/nvim/init.vim)
          (builtins.readFile ../../../nvim/.config/nvim/settings/floatterm.vim)
          (builtins.readFile ../../../nvim/.config/nvim/settings/styling.vim)
          (builtins.readFile ../../../nvim/.config/nvim/settings/telescope.vim)
    '';
    plugins = [
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

  programs.fish.enable = true;
  programs.fzf.enable = true;
  programs.exa.enable = true;
  programs.bat.enable = true;
  programs.gh.enable = true;
  programs.direnv.enable = true;

  home.packages = [pkgs.visidata];

}

{ config, pkgs, ... }:
let
  unstable = import <nixpkgs-unstable> {};
  copilot-vim = pkgs.vimUtils.buildVimPlugin {
        name = "copilot-vim";
        src = pkgs.fetchFromGitHub {
          owner = "github";
          repo = "copilot.vim";
          rev = "47eb231463d3654de1a205c4e30567fbd006965d";
          sha256 = "06znz1869h7cdh9xc0b54mysslgpf3qdwsj5zvnzrzk6fnfin03q";
        };
      };
in rec
{
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile .config/nvim/init.vim)
      (builtins.readFile .config/nvim/settings/floatterm.vim)
      (builtins.readFile .config/nvim/settings/styling.vim)
      (builtins.readFile .config/nvim/settings/telescope.vim)
    ]);    plugins = [
      unstable.vimPlugins.nord-vim 
      unstable.vimPlugins.papercolor-theme 
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
      copilot-vim
      
    ];
  };

}

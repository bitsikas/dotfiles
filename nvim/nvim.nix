{ config, pkgs, ... }:

let
  nvim-spell-fr-utf8-dictionary = builtins.fetchurl {
    url = "http://ftp.vim.org/vim/runtime/spell/ro.utf-8.spl";
    sha256 = "abc1e405496c6f23dfa50c103ca523b30e92f4fc3d0db2a11054d9ae1d785a01";
  };
in {

  home.file."${config.xdg.configHome}/nvim/spell/ro.utf-8.spl".source = nvim-spell-fr-utf8-dictionary;

  programs.neovim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile .config/nvim/init.vim)
      (builtins.readFile .config/nvim/settings/floatterm.vim)
      (builtins.readFile .config/nvim/settings/styling.vim)
      (builtins.readFile .config/nvim/settings/telescope_settings.vim)
      (builtins.readFile .config/nvim/settings/treesitter.vim)
      (builtins.readFile .config/nvim/settings/lsp.vim)
      (builtins.readFile .config/nvim/settings/toggleterm.vim)
      (builtins.readFile .config/nvim/settings/lualine.vim)
      (builtins.readFile .config/nvim/settings/trouble.vim)
      (builtins.readFile .config/nvim/settings/nvim-compe.vim)
      # (builtins.readFile .config/nvim/settings/neorg.vim)
    ]);
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-dart
          tree-sitter-fish
          tree-sitter-go
          tree-sitter-hcl
          tree-sitter-html
          tree-sitter-http
          tree-sitter-java
          tree-sitter-javascript
          tree-sitter-lua
          tree-sitter-make
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-norg
          tree-sitter-python
          tree-sitter-typescript
          tree-sitter-sql
        ]))
      pkgs.vimPlugins.editorconfig-vim
      pkgs.vimPlugins.bracey-vim
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.gitgutter
      # pkgs.vimPlugins.gruvbox
      pkgs.vimPlugins.nvim-solarized-lua
      pkgs.vimPlugins.indentLine
      #pkgs.vimPlugins.nord-vim 
      pkgs.vimPlugins.nvim-compe
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-lsputils
      pkgs.vimPlugins.toggleterm-nvim
      pkgs.vimPlugins.trouble-nvim
      pkgs.vimPlugins.markdown-preview-nvim
      # pkgs.vimPlugins.nvim-tree-lua
      #pkgs.vimPlugins.papercolor-theme 
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
      # pkgs.vimPlugins.bufferline-nvim
      pkgs.vimPlugins.vim-commentary
      #pkgs.vimPlugins.vim-floaterm
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-terraform
      pkgs.vimPlugins.vim-tmux-navigator
      pkgs.vimPlugins.vim-python-pep8-indent
      #pkgs.vimPlugins.vim-surround
      #pkgs.vimPlugins.vimspector
      pkgs.vimPlugins.copilot-vim
      pkgs.vimPlugins.flutter-tools-nvim
      # pkgs.vimPlugins.neorg

    ];
  };
  home.packages = with pkgs; [ pyright ];

}

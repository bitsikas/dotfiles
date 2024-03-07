{ config, pkgs,... }:

let
  nvim-spell-ro-utf8-dictionary = builtins.fetchurl {
    url = "http://ftp.vim.org/vim/runtime/spell/ro.utf-8.spl";
    sha256 = "abc1e405496c6f23dfa50c103ca523b30e92f4fc3d0db2a11054d9ae1d785a01";
  };
  nvim-spell-en-utf8-dictionary = builtins.fetchurl {
    url = "http://ftp.vim.org/vim/runtime/spell/en.utf-8.spl";
    sha256 = "fecabdc949b6a39d32c0899fa2545eab25e63f2ed0a33c4ad1511426384d3070";
  };
in {

  home.file."${config.xdg.configHome}/nvim/spell/ro.utf-8.spl".source = nvim-spell-ro-utf8-dictionary;
  home.file."${config.xdg.configHome}/nvim/spell/en.utf-8.spl".source = nvim-spell-en-utf8-dictionary;

  programs.neovim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile .config/nvim/init.vim)
      # (builtins.readFile .config/nvim/settings/floatterm.vim)
      (builtins.readFile .config/nvim/settings/telescope_settings.vim)
      (builtins.readFile .config/nvim/settings/treesitter.vim)
      (builtins.readFile .config/nvim/settings/lsp.vim)
      # (builtins.readFile .config/nvim/settings/toggleterm.vim)
      # (builtins.readFile .config/nvim/settings/coverage.vim)
      # (builtins.readFile .config/nvim/settings/lualine.vim)
      (builtins.readFile .config/nvim/settings/trouble.vim)
      # (builtins.readFile .config/nvim/settings/nvim-compe.vim)
      (builtins.readFile .config/nvim/settings/cmp.vim)
      (builtins.readFile .config/nvim/settings/navic.vim)
      (builtins.readFile .config/nvim/settings/styling.vim)
      # (builtins.readFile .config/nvim/settings/neorg.vim)
    ]);
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-c
          tree-sitter-cpp
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
          tree-sitter-rust
          tree-sitter-sql
        ]))
      # pkgs.vimPlugins.nvim-treesitter-context
      pkgs.vimPlugins.editorconfig-vim
      pkgs.vimPlugins.bracey-vim
      # pkgs.vimPlugins.lualine-nvim
      # pkgs.vimPlugins.gitgutter
      pkgs.vimPlugins.gitsigns-nvim
      # pkgs.vimPlugins.solarized-nvim
      pkgs.vimPlugins.NeoSolarized
      pkgs.vimPlugins.catppuccin-nvim
      # pkgs.vimPlugins.indentLine
      #pkgs.vimPlugins.nord-vim 
      pkgs.vimPlugins.nvim-cmp
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp_luasnip
      # pkgs.vimPlugins.nvim-lspconfig
      # pkgs.vimPlugins.nvim-lsputils
      pkgs.vimPlugins.lsp-zero-nvim
      # pkgs.vimPlugins.toggleterm-nvim
      pkgs.vimPlugins.trouble-nvim
      pkgs.vimPlugins.nvim-navic
      pkgs.vimPlugins.suda-vim
      pkgs.vimPlugins.nvim-navbuddy
      pkgs.vimPlugins.markdown-preview-nvim
      # pkgs.vimPlugins.nvim-tree-lua
      #pkgs.vimPlugins.papercolor-theme 
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
      # pkgs.vimPlugins.bufferline-nvim
      pkgs.vimPlugins.vim-commentary


      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "harpoon2";
          version = "2024-01-26";
          src = pkgs.fetchFromGitHub {
            owner = "ThePrimeagen";
            repo = "harpoon";
            rev = "a38be6e0dd4c6db66997deab71fc4453ace97f9c";
            sha256 = "1cmiw4sy5r4h8f2k1m91f2xykasnp66zdibx0l8vk94hw990sg26";
          };
          meta.homepage = "https://github.com/ThePrimeagen/harpoon/";
        }
      )

      (
        pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-coverage";
          version = "2023-07-20";
          src = pkgs.fetchFromGitHub {
            owner = "andythigpen";
            repo = "nvim-coverage";
            rev = "4634dfb00961a86948518c7e6f85737c24364308";
            sha256 = "0ry8b5945spz00scab6xxs8va56yg17q1dd6g90k3zm9gvdi0r79";
          };
          meta.homepage = "https://github.com/andythigpen/nvim-coverage/";
        }
        )
      #pkgs.vimPlugins.vim-floaterm
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-terraform
      # pkgs.vimPlugins.vim-tmux-navigator
      # pkgs.vimPlugins.vim-python-pep8-indent
      #pkgs.vimPlugins.vim-surround
      #pkgs.vimPlugins.vimspector
      pkgs.vimPlugins.copilot-lua
      pkgs.vimPlugins.copilot-cmp
      pkgs.vimPlugins.flutter-tools-nvim
      pkgs.vimPlugins.undotree
      # pkgs.vimPlugins.neorg

    ];
  };
  home.packages = with pkgs; [ pyright ];

}

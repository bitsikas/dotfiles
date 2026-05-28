{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  darwin,
  ...
}: let
  nvim-spell-ro-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/ro.utf-8.spl";
    sha256 = "abc1e405496c6f23dfa50c103ca523b30e92f4fc3d0db2a11054d9ae1d785a01";
  };
  nvim-spell-en-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/en.utf-8.spl";
    sha256 = "fecabdc949b6a39d32c0899fa2545eab25e63f2ed0a33c4ad1511426384d3070";
  };
in {
  home.file."${config.xdg.configHome}/nvim/spell/ro.utf-8.spl".source = nvim-spell-ro-utf8-dictionary;
  home.file."${config.xdg.configHome}/nvim/spell/en.utf-8.spl".source = nvim-spell-en-utf8-dictionary;

  programs.neovim = lib.mkIf config.myFeatures.desktop {
    package = pkgs.neovim-unwrapped;
    enable = true;
    extraConfig = (
      builtins.concatStringsSep "\n" [
        (builtins.readFile .config/nvim/init.vim)
        # (builtins.readFile .config/nvim/settings/floatterm.vim)
        (builtins.readFile .config/nvim/settings/telescope_settings.vim)
        (builtins.readFile .config/nvim/settings/treesitter.vim)
        (builtins.readFile .config/nvim/settings/lsp.vim)
        # (builtins.readFile .config/nvim/settings/toggleterm.vim)
        # (builtins.readFile .config/nvim/settings/coverage.vim)
        (builtins.readFile .config/nvim/settings/lualine.vim)
        (builtins.readFile .config/nvim/settings/trouble.vim)
        # (builtins.readFile .config/nvim/settings/nvim-compe.vim)
        (builtins.readFile .config/nvim/settings/cmp.vim)
        (builtins.readFile .config/nvim/settings/conform.vim)
        # (builtins.readFile .config/nvim/settings/navic.vim)
        (builtins.readFile .config/nvim/settings/styling.vim)
        (builtins.readFile .config/nvim/settings/neorg.vim)
      ]
    );
    plugins = [
      # nixpkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [p.c p.java p.python p.zig p.rust p.php p.javascript p.html p.nu p.json p.make p.markdown p.markdown-inline p.lua p.http p.go p.dockerfile p.css p.comment p.cmake p.bash p.yaml p.vim p.typescript p.toml p.sql p.perl]))
      pkgs.vimPlugins.editorconfig-vim
      {
        plugin = pkgs.vimPlugins.bracey-vim;
        optional = true;
      }

      # pkgs.vimPlugins.NeoSolarized
      # pkgs.vimPlugins.bufferline-nvim
      # pkgs.vimPlugins.gitgutter
      # pkgs.vimPlugins.indentLine
      # pkgs.vimPlugins.nord-vim
      # pkgs.vimPlugins.nvim-lspconfig
      # pkgs.vimPlugins.nvim-lsputils
      # pkgs.vimPlugins.nvim-tree-lua
      # pkgs.vimPlugins.octo-nvim
      # pkgs.vimPlugins.papercolor-theme
      # pkgs.vimPlugins.solarized-nvim
      # pkgs.vimPlugins.toggleterm-nvim
      # pkgs.vimPlugins.vim-floaterm
      # pkgs.vimPlugins.vim-python-pep8-indent
      # pkgs.vimPlugins.vim-surround
      # pkgs.vimPlugins.vimspector
      {
        plugin = pkgs.vimPlugins.CopilotChat-nvim;
        optional = true;
      }
      pkgs.vimPlugins.catppuccin-nvim
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.conform-nvim
      {
        plugin = pkgs.vimPlugins.copilot-cmp;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.copilot-lua;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.flutter-tools-nvim;
        optional = true;
      }
      pkgs.vimPlugins.gitsigns-nvim
      {
        plugin = pkgs.vimPlugins.harpoon2;
        optional = true;
      }
      pkgs.vimPlugins.indent-blankline-nvim-lua
      pkgs.vimPlugins.lsp-zero-nvim
      pkgs.vimPlugins.lualine-nvim
      pkgs.vimPlugins.luasnip
      {
        plugin = pkgs.vimPlugins.markdown-preview-nvim;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.neorg;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.neotest;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.neotest-python;
        optional = true;
      }
      pkgs.vimPlugins.nvim-cmp
      {
        plugin = pkgs.vimPlugins.nvim-coverage;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.nvim-navbuddy;
        optional = true;
      }
      pkgs.vimPlugins.nvim-navic
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.snacks-nvim
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.trouble-nvim;
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.undotree;
        optional = true;
      }
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-oscyank
      pkgs.vimPlugins.vim-terraform
      # pkgs.vimPlugins.vim-test
      pkgs.vimPlugins.vim-tmux-navigator
    ];
  };
  home.packages = lib.mkIf config.myFeatures.desktop [
    pkgs.nodejs_22
    # temp disable to try them per project
    # pkgs.pyright
    # nixpkgs-unstable.ruff-lsp
    # pkgs.tailwindcss-language-server
    # pkgs.cmake-language-server
    # pkgs.lua-language-server
    # pkgs.clang-tools_14
    # pkgs.vscode-langservers-extracted
  ];
}

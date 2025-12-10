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

  programs.neovim = {
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
      pkgs.vimPlugins.bracey-vim
      pkgs.vimPlugins.lualine-nvim
      # pkgs.vimPlugins.gitgutter
      pkgs.vimPlugins.gitsigns-nvim
      # pkgs.vimPlugins.solarized-nvim
      pkgs.vimPlugins.NeoSolarized
      pkgs.vimPlugins.catppuccin-nvim
      # pkgs.vimPlugins.indentLine
      # pkgs.vimPlugins.nord-vim
      pkgs.vimPlugins.nvim-cmp
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.luasnip
      # pkgs.vimPlugins.nvim-lspconfig
      # pkgs.vimPlugins.nvim-lsputils
      pkgs.vimPlugins.lsp-zero-nvim
      pkgs.vimPlugins.vim-test
      # pkgs.vimPlugins.toggleterm-nvim
      pkgs.vimPlugins.trouble-nvim
      pkgs.vimPlugins.CopilotChat-nvim
      # pkgs.vimPlugins.octo-nvim
      pkgs.vimPlugins.nvim-navic
      pkgs.vimPlugins.vim-suda
      pkgs.vimPlugins.nvim-navbuddy
      pkgs.vimPlugins.markdown-preview-nvim
      # pkgs.vimPlugins.nvim-tree-lua
      # pkgs.vimPlugins.papercolor-theme
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.telescope-nvim
      # pkgs.vimPlugins.bufferline-nvim
      pkgs.vimPlugins.vim-commentary
      pkgs.vimPlugins.nvim-coverage
      pkgs.vimPlugins.vim-tmux-navigator
      pkgs.vimPlugins.indent-blankline-nvim-lua
      pkgs.vimPlugins.harpoon2
      pkgs.vimPlugins.nvim-coverage

      # pkgs.vimPlugins.vim-floaterm
      pkgs.vimPlugins.vim-fugitive
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.vim-terraform
      pkgs.vimPlugins.vim-tmux-navigator
      # pkgs.vimPlugins.vim-python-pep8-indent
      # pkgs.vimPlugins.vim-surround
      # pkgs.vimPlugins.vimspector
      pkgs.vimPlugins.copilot-lua
      pkgs.vimPlugins.copilot-cmp
      pkgs.vimPlugins.flutter-tools-nvim
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.conform-nvim
      pkgs.vimPlugins.snacks-nvim
      pkgs.vimPlugins.snacks-nvim
      pkgs.vimPlugins.vim-oscyank
      pkgs.vimPlugins.neorg
    ];
  };
  home.packages = [
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

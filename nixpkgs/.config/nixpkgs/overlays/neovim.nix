let
  unstable = import (fetchTarball https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz) { };
in self: super: {
  neovim = unstable.neovim.override {
    configure = {
      customRC = (builtins.concatStringsSep "\n" [
        (builtins.readFile ../../../../nvim/.config/nvim/init.vim)
        # (builtins.readFile ../../../../nvim/.config/nvim/settings/vimwiki.vim)
        # (builtins.readFile ../../../../nvim/.config/nvim/settings/coc.vim)
        (builtins.readFile ../../../../nvim/.config/nvim/settings/floatterm.vim)
        (builtins.readFile ../../../../nvim/.config/nvim/settings/styling.vim)
        (builtins.readFile ../../../../nvim/.config/nvim/settings/telescope.vim)
      ]);
      packages.myVimPackage = with unstable.pkgs.vimPlugins; {
        start = [ 
          editorconfig-vim 
          gitgutter nord-vim 
          unstable.vimPlugins.nvim-lspconfig
          plenary-nvim 
          telescope-nvim 
          vim-airline 
          vim-airline-themes
          vim-commentary
          vim-floaterm
          vim-fugitive
          vim-nix
          vim-surround
          vimspector
          unstable.vimPlugins.nvim-lsputils
          unstable.vimPlugins.nvim-compe

        ];

        opt = [];
      };
    };
  };
}

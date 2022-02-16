self: super: {
  neovim = super.neovim.override {
    configure = {

      customRC = ''

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set noswapfile


source ~/.config/nvim/settings/floatterm.vim
source ~/.config/nvim/settings/styling.vim
source ~/.config/nvim/settings/telescope.vim


" Ignore editorconfig for vim-fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:dart_style_guide = 2

imap jk <Esc>

let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "

      '';
      packages.myVimPackage = with super.pkgs.vimPlugins; {
# see examples below how to use custom packages
start = [ 
  editorconfig-vim
  gitgutter 
  nord-vim 
  coc-nvim
  coc-pyright
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

];
# If a Vim plugin has a dependency that is not explicitly listed in
# opt that dependency will always be added to start to avoid confusion.
opt = [ ];
                              };
                            };
                          };
                        }

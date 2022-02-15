set nocompatible
"set shell=/bin/bash

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'arcticicestudio/nord-vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'editorconfig/editorconfig-vim'
Plug 'pwntester/octo.nvim',
Plug 'kyazdani42/nvim-web-devicons',
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'puremourning/vimspector'
Plug 'saltstack/salt-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'voldikss/vim-floaterm'
Plug 'github/copilot.vim'

call plug#end()

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set noswapfile


source ~/.config/nvim/settings/vimwiki.vim
source ~/.config/nvim/settings/coc.vim
source ~/.config/nvim/settings/floatterm.vim
source ~/.config/nvim/settings/styling.vim
source ~/.config/nvim/settings/telescope.vim


" Ignore editorconfig for vim-fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:dart_style_guide = 2

imap jk <Esc>

let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "


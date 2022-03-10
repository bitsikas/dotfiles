set nocompatible
"set shell=/bin/bash

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set noswapfile

" Ignore editorconfig for vim-fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:dart_style_guide = 2

imap jk <Esc>

let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "

lua require 'lspconfig'.pyright.setup{}
lua require 'lspconfig'.rnix.setup{}
lua require 'lspconfig'.tailwindcss.setup{}
lua require 'compe'.setup {enabled=true; autocomplete=true;source={path=true;nvim_lsp=true,treesitter=true}}

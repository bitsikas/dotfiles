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
let g:indentLine_enabled = 1

noremap <silent> <m-h> :TmuxNavigateLeft<cr>
noremap <silent> <m-j> :TmuxNavigateDown<cr>
noremap <silent> <m-k> :TmuxNavigateUp<cr>

noremap <silent> <m-l> :TmuxNavigateRight<cr>
lua << EOF
require('gitsigns').setup()
require("copilot").setup({
  suggestion = {enabled = false},
  panel = {enabled = false},
})
require("copilot_cmp").setup({})
EOF

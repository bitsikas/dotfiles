syntax on
set cmdheight=2
set tabstop=4

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Fix colors
" set background=dark
" let &t_ut=''
" set t_Co=256
" colorscheme catppuccin-frappe
set termguicolors
syntax on
" " Set gutter for CoC-nvim color to none
" highlight SignColumn ctermbg=none

" Use hybrid line numbers
set number relativenumber
" set nu rnu

lua << EOF
require"catppuccin".setup({
	    background = { -- :h background
        light = "latte",
        dark = "frappe",
    },
})
vim.cmd.colorscheme "catppuccin"

EOF
" colorscheme catppuccin

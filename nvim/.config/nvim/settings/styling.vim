syntax on
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Fix colors
" set background=dark
let &t_ut=''
set t_Co=256
colorscheme NeoSolarized
set termguicolors
syntax on
" " Set gutter for CoC-nvim color to none
" highlight SignColumn ctermbg=none


" Use hybrid line numbers
set number relativenumber
set nu rnu


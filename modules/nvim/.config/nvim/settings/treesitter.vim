"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
syntax on

lua <<EOF

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.smartindent = false

EOF




"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
"
" vim.api.nvim_create_autocmd({ "BufEnter" }, {
"     pattern = { "*" },
"     command = "normal zx zR",
" })

lua <<EOF

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF




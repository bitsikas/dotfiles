"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

lua <<EOF

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    command = "normal zx zR",
})
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "norg" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF




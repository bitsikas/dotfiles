set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

lua <<EOF
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    command = "normal zx zR",
})
EOF
lua <<EOF
	require'nvim-treesitter.configs'.setup {
	  highlight = {
	    enable = true,
	    additional_vim_regex_highlighting = false,
	  },
	}
EOF




"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
syntax on

lua <<EOF

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.smartindent = false

require'nvim-treesitter.configs'.setup {
    indent = {
	    enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
}
EOF




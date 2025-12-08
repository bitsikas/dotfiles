lua << EOF

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
		lsp_zero.default_keymaps({buffer = bufnr})
		if client.server_capabilities.documentSymbolProvider then
			require('nvim-navic').attach(client, bufnr)
		end
end)
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('htmx')
vim.lsp.enable('superhtml')
vim.lsp.enable('gopls')
vim.lsp.enable('ccls')
vim.lsp.enable('nixd')

EOF

nmap <C-p>j  :Navbuddy<cr>

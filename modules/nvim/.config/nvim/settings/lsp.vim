lua << EOF

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
		lsp_zero.default_keymaps({buffer = bufnr})
		if client.server_capabilities.documentSymbolProvider then
			require('nvim-navic').attach(client, bufnr)
		end
end)
require'lspconfig'.ruff.setup({})
require'lspconfig'.pyright.setup({})
require'lspconfig'.tailwindcss.setup({})
require'lspconfig'.htmx.setup{}
require'lspconfig'.superhtml.setup{}
require'lspconfig'.gopls.setup{}

EOF

nmap <C-p>j  :Navbuddy<cr>

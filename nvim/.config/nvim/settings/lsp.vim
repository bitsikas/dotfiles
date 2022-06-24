lua require 'lspconfig'.pyright.setup{}
lua require 'lspconfig'.rnix.setup{}
lua require 'lspconfig'.tailwindcss.setup{}
lua require 'compe'.setup {enabled=true; autocomplete=true;source={path=true;nvim_lsp=true,treesitter=true}}


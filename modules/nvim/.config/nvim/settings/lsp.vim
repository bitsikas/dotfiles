lua << EOF
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
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

local navbuddy_loaded = false

_G.open_navbuddy = function()
  if not navbuddy_loaded then
    vim.cmd('packadd nvim-navbuddy')
    require('nvim-navbuddy').setup({
      lsp = {
        auto_attach = true,
      },
      source_buffer = {
        follow_node = false,
      },
      window = {
        sections = {
          right = {
            preview = 'never',
          },
        },
      },
    })
    navbuddy_loaded = true
  end

  require('nvim-navbuddy').open(vim.api.nvim_get_current_buf())
end
EOF

nmap <C-p>j <cmd>lua _G.open_navbuddy()<cr>

lua << EOF
require("conform").setup({

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 5000,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = {"black", "ruff_format" },
    nix = { "alejandra" },
    html = { "superhtml" },
    htmldjango = { "superhtml" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
EOF
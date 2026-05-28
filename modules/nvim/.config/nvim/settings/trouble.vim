lua << EOF
local trouble_loaded = false

local function ensure_trouble()
  if trouble_loaded then
    return
  end

  vim.cmd("packadd trouble.nvim")

  require("trouble").setup({
    fold_open = "v",
    fold_closed = ">",
    mode = "diagnostics",
  })

  trouble_loaded = true
end

_G.toggle_trouble_diagnostics = function()
  ensure_trouble()
  vim.cmd("Trouble diagnostics toggle filter.buf=0")
end
EOF

nnoremap <leader>xd <cmd>lua _G.toggle_trouble_diagnostics()<cr>

lua << EOF
local neorg_loaded = false

local function ensure_neorg()
  if neorg_loaded then
    return
  end

  vim.cmd("packadd neorg")

  require("neorg").setup({
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/work/notes",
          },
          default_workspace = "notes",
        },
      },
    },
  })

  neorg_loaded = true
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  pattern = "*.norg",
  callback = ensure_neorg,
})
EOF

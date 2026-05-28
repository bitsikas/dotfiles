lua << EOF
local telescope_loaded = false

local function ensure_telescope()
  if telescope_loaded then
    return
  end

  vim.cmd("packadd telescope.nvim")

  require("telescope").setup({
    defaults = {
      file_ignore_patterns = { ".git", "node_modules" },
    },
  })

  telescope_loaded = true
end

local function with_builtin(fn_name, opts)
  ensure_telescope()
  require("telescope.builtin")[fn_name](opts or {})
end

_G.telescope_find_files = function()
  with_builtin("find_files", { hidden = true })
end

_G.telescope_live_grep = function()
  with_builtin("live_grep", { hidden = true })
end

_G.telescope_live_grep_no_tests = function()
  with_builtin("live_grep", {
    hidden = true,
    glob_pattern = "!*test*",
  })
end

_G.telescope_grep_string = function()
  with_builtin("grep_string", { hidden = true })
end
EOF

nmap <C-p>f <cmd>lua _G.telescope_find_files()<cr>
xmap <C-p>f <cmd>lua _G.telescope_find_files()<cr>
nmap <C-p>g <cmd>lua _G.telescope_live_grep()<cr>
xmap <C-p>g <cmd>lua _G.telescope_live_grep()<cr>
nmap <C-p>c <cmd>lua _G.telescope_live_grep_no_tests()<cr>
xmap <C-p>c <cmd>lua _G.telescope_live_grep_no_tests()<cr>
nmap <C-p>d <cmd>lua _G.telescope_grep_string()<cr>
xmap <C-p>d <cmd>lua _G.telescope_grep_string()<cr>

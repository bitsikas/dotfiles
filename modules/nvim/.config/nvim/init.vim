set nocompatible
"set shell=/bin/bash

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set noswapfile

" Ignore editorconfig for vim-fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:dart_style_guide = 2

imap jk <Esc>

let g:vimspector_enable_mappings = 'HUMAN'
let mapleader = " "
let maplocalleader = ","
let g:indentLine_enabled = 1
let g:suda#nopass = 1

nnoremap <F5> <cmd>lua _G.toggle_undotree()<CR>

if has("persistent_undo")
		let target_path = expand('~/.undodir')

		if !isdirectory(target_path)
				call mkdir(target_path, "p", 0700)
		endif

		let &undodir=target_path
		set undofile
endif

lua << EOF
vim.g.polyglot_disabled = { "ftdetect" }

local loaded_plugins = {}
local function packadd(name)
  if loaded_plugins[name] then
    return
  end

  vim.cmd("packadd " .. name)
  loaded_plugins[name] = true
end

local harpoon = nil
local function get_harpoon()
  if harpoon ~= nil then
    return harpoon
  end

  packadd("harpoon2")
  harpoon = require("harpoon")
  harpoon:setup()
  return harpoon
end

local coverage_loaded = false
local coverage_commands = {
  "Coverage",
  "CoverageLoad",
  "CoverageLoadLcov",
  "CoverageShow",
  "CoverageHide",
  "CoverageToggle",
  "CoverageClear",
  "CoverageSummary",
}

local function ensure_coverage()
  if coverage_loaded then
    return
  end

  for _, cmd in ipairs(coverage_commands) do
    pcall(vim.api.nvim_del_user_command, cmd)
  end

  packadd("nvim-coverage")
  require("coverage").setup()
  coverage_loaded = true
end

_G.toggle_undotree = function()
  packadd("undotree")
  vim.cmd("UndotreeToggle")
end

require('gitsigns').setup()
require("ibl").setup({})

vim.keymap.set("n", "<leader>a", function()
  get_harpoon():list():add()
end)

vim.keymap.set("n", "<C-e>", function()
  local h = get_harpoon()
  h.ui:toggle_quick_menu(h:list())
end)

vim.keymap.set("n", "<leader>p", function()
  get_harpoon():list():prev()
end)

vim.keymap.set("n", "<leader>n", function()
  get_harpoon():list():next()
end)

require("nvim-navic").setup({ highlight = true })

vim.api.nvim_create_user_command("Coverage", function()
  ensure_coverage()
  vim.cmd("Coverage")
end, {})

vim.api.nvim_create_user_command("CoverageLoad", function()
  ensure_coverage()
  vim.cmd("CoverageLoad")
end, {})

vim.api.nvim_create_user_command("CoverageLoadLcov", function(args)
  ensure_coverage()
  vim.cmd("CoverageLoadLcov " .. args.args)
end, { nargs = "?", complete = "file" })

vim.api.nvim_create_user_command("CoverageShow", function()
  ensure_coverage()
  vim.cmd("CoverageShow")
end, {})

vim.api.nvim_create_user_command("CoverageHide", function()
  ensure_coverage()
  vim.cmd("CoverageHide")
end, {})

vim.api.nvim_create_user_command("CoverageToggle", function()
  ensure_coverage()
  vim.cmd("CoverageToggle")
end, {})

vim.api.nvim_create_user_command("CoverageClear", function()
  ensure_coverage()
  vim.cmd("CoverageClear")
end, {})

vim.api.nvim_create_user_command("CoverageSummary", function()
  ensure_coverage()
  vim.cmd("CoverageSummary")
end, {})

-- require("neotest").setup({
--   adapters = {
--     require("neotest-python")
--   }
-- })
-- require("octo").setup({ enable_builtin = true })
-- vim.cmd([[hi OctoEditable guibg=none]])
EOF

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
let g:indentLine_enabled = 1
let g:suda#nopass = 1

nnoremap <F5> :UndotreeToggle<CR>

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
require('gitsigns').setup()
require("copilot").setup({
  suggestion = {enabled = false},
  panel = {enabled = false},
})
require("copilot_cmp").setup({})
require("CopilotChat").setup {
  -- See Configuration section for rest
}
require("ibl").setup({})
harpoon = require("harpoon").setup({})
vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>p", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end)
require"nvim-navic".setup({highlight=true})
require("coverage").setup()
require'nvim-web-devicons'.setup()
require("octo").setup({ enable_builtin = true })
vim.cmd([[hi OctoEditable guibg=none]])

EOF

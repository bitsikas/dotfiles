lua << EOF
require("trouble").setup {
	fold_open = "v", -- icon used for open folds
	fold_closed = ">", -- icon used for closed folds
	mode = "diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	}
EOF
nnoremap <leader>xd <cmd>TroubleToggle diagnostics<cr>

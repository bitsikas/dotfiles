lua << EOF
require("trouble").setup {
	icons = false,
	fold_open = "v", -- icon used for open folds
	fold_closed = ">", -- icon used for closed folds
	indent_lines = false, -- add an indent guide below the fold icons
	mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	signs = {
		-- icons / text used for a diagnostic
		error = "error",
		warning = "warn",
		hint = "hint",
		information = "info"
		},
	use_diagnostic_signs = false
	}
EOF
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>

lua << EOF


require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = {},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {},

	inactive_winbar = {
			lualine_a = {
					{'filename', path=1}
			},
		lualine_b = {
			"navic",
			color_correction = nil,
			navic_opts = nil
		}
		},
	winbar = {
			lualine_a = {
					{'filename', path=1}
			},
		lualine_b = {
			"navic",
			color_correction = nil,
			navic_opts = nil
		}
	}
}
EOF

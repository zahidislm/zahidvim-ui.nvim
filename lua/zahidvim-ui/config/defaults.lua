local default_config = {
	globals = {
		icons = {
			enable_nerdfont = false,
			enable_devicons = false,
			override = nil,
			setup_listchars = true,
		},
	},
	ui = {
		statusline = {
			enabled = true,
			enable_autocmds = true,
			components = {
				mode = { enabled = true },
				git = { enabled = true },
				diagnostics = { enabled = true },
				lsp = { enabled = true },
				macro = { enabled = true },
				search = { enabled = true },
				filetype = { enabled = true },
				ruler = { enabled = true },
			},
		},

		statuscolumn = {
			enabled = true,
			components = {
				git = { enabled = true },
				diagnostics = { enabled = true },
				line_number = { enabled = true },
				fold_indicator = { enabled = true },
			},
		},
	},

	highlights = { enable_fallback = true },
}

return default_config

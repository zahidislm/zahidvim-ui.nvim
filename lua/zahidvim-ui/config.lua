local M = {}

local defaults = {
	ui = {
		icons = {
			enable_nerdfont = false,
			enable_devicons = false,
			override = nil,
			setup_listchars = true,
		},
	},

	statusline = {
		enabled = true,
		enable_autocmds = true,
	},

	statuscolumn = {
		enabled = true,
	},
}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", defaults, options or {})
	return M.options
end

return M

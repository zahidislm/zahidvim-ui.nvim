local M = {}
local conditions = require("heirline.conditions")
local config = require("zahidvim-ui.config")

local align = { provider = "%=" }
local spacer = { provider = " " }

-- Buftypes which should cause elements to be hidden
local buftypes = {
	"nofile",
	"prompt",
	"help",
	"quickfix",
}

-- Filetypes which force the statusline to be inactive
local force_inactive_filetypes = {
	"^lazy$",
	"^mason$",
	"^TelescopePrompt$",
}

local function setup_statusline()
	local statusline = require("zahidvim-ui.modules.statusline")

	if config.options.ui.statusline.enable_autocmds then
		statusline.setup_autocmds()
	end

	local opts = {
		statusline = {
			static = {
				buftypes = buftypes,
				force_inactive_filetypes = force_inactive_filetypes,
			},

			condition = function(self)
				return not conditions.buffer_matches({
					filetype = self.force_inactive_filetypes,
				})
			end,
			config.options.ui.statusline.components.mode.enabled and statusline.mode(),
			config.options.ui.statusline.components.git.enabled and statusline.git_branch(),
			config.options.ui.statusline.components.diagnostics.enabled and statusline.diagnostics(),
			align,
			config.options.ui.statusline.components.lsp.enabled and statusline.lsp_status,
			config.options.ui.statusline.components.filetype.enabled and statusline.file_info,
			config.options.ui.statusline.components.macro.enabled and statusline.macro_record,
			config.options.ui.statusline.components.search.enabled and statusline.search_results,
			config.options.ui.statusline.components.ruler.enabled and statusline.ruler,
		},
	}

	return opts
end

local function setup_statuscolumn()
	local statuscolumn = require("zahidvim-ui.modules.statuscolumn")

	local opts = {
		statuscolumn = {
			condition = function()
				return not conditions.buffer_matches({
					filetype = force_inactive_filetypes,
				})
			end,
			static = statuscolumn.static(),
			init = statuscolumn.init,
			config.options.ui.statuscolumn.components.git.enabled and statuscolumn.gitsigns(),
			config.options.ui.statuscolumn.components.diagnostics.enabled and statuscolumn.diagnostics(),
			align,
			config.options.ui.statuscolumn.components.line_number.enabled and statuscolumn.line_numbers(),
			spacer,
			config.options.ui.statuscolumn.components.fold_indicator.enabled and statuscolumn.folds(),
		},
	}

	return opts
end

M.heirline_opts = {}

function M.setup()
	if config.options.ui.statusline.enabled then
		local opts = setup_statusline()
		M.heirline_opts = vim.tbl_deep_extend("force", M.heirline_opts, opts)
	end

	if config.options.ui.statuscolumn.enabled then
		local opts = setup_statuscolumn()
		M.heirline_opts = vim.tbl_deep_extend("force", M.heirline_opts, opts)
	end

	return M.heirline_opts
end

return M

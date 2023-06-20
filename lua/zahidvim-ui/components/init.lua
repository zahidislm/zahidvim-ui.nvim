local config = require("zahidvim-ui.config")

local conditions = require("heirline.conditions")
local statusline = require("zahidvim-ui.components.statusline")
local statuscolumn = require("zahidvim-ui.components.statuscolumn")

local heirline_opts = {}
local statusline_git = { provider = "" }
local statuscolumn_git = { provider = "" }

local gitsigns_installed, _ = pcall(require, "gitsigns")

if gitsigns_installed then
	statusline_git = statusline.GitBranch
	statuscolumn_git = statuscolumn.git_signs
end

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

local statusline_opts = {
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
		statusline.VimMode,
		statusline_git,
		statusline.LspDiagnostics,
		align,
		statusline.LspAttached,
		statusline.FileType,
		statusline.MacroRecording,
		statusline.SearchResults,
		statusline.Ruler,
	},
}

local statuscolumn_opts = {
	statuscolumn = {
		condition = function()
			return not conditions.buffer_matches({
				filetype = force_inactive_filetypes,
			})
		end,
		static = statuscolumn.static,
		init = statuscolumn.init,
		statuscolumn_git,
		statuscolumn.diagnostics,
		align,
		statuscolumn.line_numbers,
		spacer,
		statuscolumn.folds,
	},
}

if config.get("statusline").enabled then
	heirline_opts = vim.tbl_deep_extend("force", heirline_opts, statusline_opts)
end

if config.get("statuscolumn").enabled then
	heirline_opts = vim.tbl_deep_extend("force", heirline_opts, statuscolumn_opts)
end

return heirline_opts

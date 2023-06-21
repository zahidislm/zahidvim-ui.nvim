local M = {}
local config = vim.g.ui_config

M.heirline_opts = {}

local function init_ui_module(mod, conds)
	mod = type(mod) == "string" and mod or ""

	local get_hl_func = require("heirline.utils").get_highlight
	local ui_comp = require("zahidvim-ui.components." .. mod)
	ui_comp.setup(conds, get_hl_func)

	return ui_comp
end

local function validate_gitsigns()
	local gitsigns_installed, _ = pcall(require, "gitsigns")
	return gitsigns_installed
end

function M.setup()
	local conditions = require("heirline.conditions")
	local statusline = init_ui_module("statusline", conditions)
	local statuscolumn = init_ui_module("statuscolumn", conditions)

	local statusline_git = { provider = "" }
	local statuscolumn_git = { provider = "" }

	if validate_gitsigns() then
		statusline_git = statusline.git_branch
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
			statusline.mode,
			statusline_git,
			statusline.lsp_diag,
			align,
			statusline.lsp_status,
			statusline.type_info,
			statusline.macro_record,
			statusline.search_results,
			statusline.ruler,
		},
	}

	if config.statusline.enabled then
		M.heirline_opts = vim.tbl_deep_extend("force", M.heirline_opts, statusline_opts)
	end

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

	if config.statuscolumn.enabled then
		M.heirline_opts = vim.tbl_deep_extend("force", M.heirline_opts, statuscolumn_opts)
	end

	return M.heirline_opts
end

return M

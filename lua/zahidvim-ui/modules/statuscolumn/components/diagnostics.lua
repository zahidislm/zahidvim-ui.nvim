local M = {}
local utils = require("heirline.utils")
local conds = require("heirline.conditions")

local function sign_handler(self)
	self.diag_sign = {}
	self.is_git_sign = true

	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
	local signs = vim.tbl_map(function(sign)
		return vim.fn.sign_getdefined(sign.name)[1]
	end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)

	if next(signs) then
		self.diag_sign = signs[1]

		if not self.diag_sign.name:find("GitSign") then
			self.is_git_sign = false
		end
	end
end

local function on_click_handler()
	vim.schedule(vim.diagnostic.open_float)
end

function M.setup()
	local component = {
		init = function(self)
			sign_handler(self)
		end,
		provider = function(self)
			if next(self.diag_sign) and not self.is_git_sign then
				return self.diag_sign.text
			elseif conds.has_diagnostics() then
				return " "
			end
		end,
		hl = function(self)
			if next(self.diag_sign) and not self.is_git_sign then
				return utils.get_highlight(self.diag_sign.texthl)
			end
		end,
		on_click = {
			name = "diagnostics_click",
			callback = function(self, ...)
				on_click_handler(self.click_args(self, ...))
			end,
		},
	}

	return component
end

return M

local M = {}
local icons = vim.g.ui_icons
local utils = require("heirline.utils")

local function has_gitsigns()
	local gitsigns_installed, _ = pcall(require, "gitsigns")
	return gitsigns_installed
end

local function sign_handler(self)
	local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
		group = "gitsigns_vimfn_signs_",
		id = vim.v.lnum,
		lnum = vim.v.lnum,
	})

	self.sign = #signs > 0 and signs[1].signs[1] or nil
	self.has_sign = self.sign ~= nil
end

local function on_click_handler()
	if vim.b.gitsigns_status_dict then
		vim.schedule(require("gitsigns").preview_hunk)
	end
end

function M.setup(fallback_hl)
	local component = {
		condition = has_gitsigns,
		init = function(self)
			sign_handler(self)
		end,
		provider = icons.misc.v_border,
		hl = function(self)
			if self.has_sign then
				return self.sign.name
			end

			return utils.get_highlight(fallback_hl)
		end,
		on_click = {
			name = "gitsigns_click",
			callback = function(self, ...)
				on_click_handler(self.click_args(self, ...))
			end,
		},
	}

	return component
end

return M

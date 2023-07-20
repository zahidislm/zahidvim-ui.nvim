local M = {}
local icons = vim.g.ui_icons
local utils = require("heirline.utils")

M.labels = {
	n = "NORMAL",
	no = "NORMAL",
	nov = "NORMAL",
	noV = "NORMAL",
	["no\22"] = "NORMAL",
	niI = "NORMAL",
	niR = "NORMAL",
	niV = "NORMAL",
	nt = "NORMAL",
	v = "VISUAL",
	vs = "VISUAL",
	V = "VISUAL",
	Vs = "VISUAL",
	["\22"] = "VISUAL",
	["\22s"] = "VISUAL",
	s = "SELECT",
	S = "SELECT",
	["\19"] = "SELECT",
	i = "INSERT",
	ic = "INSERT",
	ix = "INSERT",
	R = "REPLACE",
	Rc = "REPLACE",
	Rx = "REPLACE",
	Rv = "REPLACE",
	Rvc = "REPLACE",
	Rvx = "REPLACE",
	c = "COMMAND",
	cv = "Ex",
	r = "...",
	rm = "M",
	["r?"] = "?",
	["!"] = "!",
	t = "TERM",
}

M.colors = {
	n = "Magenta",
	i = "Green",
	v = "Orange",
	V = "Orange",
	["\22"] = "Orange",
	c = "Orange",
	s = "Yellow",
	S = "Yellow",
	["\19"] = "Yellow",
	r = "Green",
	R = "Green",
	["!"] = "Red",
	t = "Red",
}

function M.setup()
	local component = {
		init = function(self)
			self.mode = vim.fn.mode(1)
			self.mode_color = self.mode_colors[self.mode:sub(1, 1)]
		end,
		static = {
			mode_names = M.labels,
			mode_colors = M.colors,
		},
		{
			provider = function(self)
				return " %2(" .. self.mode_names[self.mode] .. "%) "
			end,
			hl = function(self)
				local custom_hl = utils.get_highlight("Heirline" .. self.mode_color).bg
				return {
					fg = "bg",
					bg = custom_hl or string.lower(self.mode_color),
				}
			end,
		},
		{
			provider = icons.statusline.left_slant,
			hl = function(self)
				local custom_hl = utils.get_highlight("Heirline" .. self.mode_color).fg
				return {
					fg = custom_hl or string.lower(self.mode_color),
					bg = "bg",
				}
			end,
		},
	}
	return component
end

return M

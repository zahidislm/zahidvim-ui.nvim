local utils = require("heirline.utils")
local M = {}

local statusline_bg = "#bebebe"

if vim.o.background == "dark" then
	statusline_bg = "#2e323b"
end

local highlights = {
	Slant = { fg = statusline_bg, bg = "bg" },
	SlantInv = { fg = "bg", bg = statusline_bg },
	SlantError = { bg = "bg", fg = "red" },
	SlantWarn = { bg = "bg", fg = "yellow" },
	SlantRuler = { fg = "gray", bg = "bg" },
	SlantInvMacro = { fg = "blue", bg = "bg" },
	Group = { fg = "gray", bg = statusline_bg },
	GitAdded = { fg = "green", bg = statusline_bg },
	GitChanged = { fg = "gray", bg = statusline_bg },
	GitRemoved = { fg = "red", bg = statusline_bg },
	DiagError = { fg = "bg", bg = "red" },
	DiagWarn = { fg = "bg", bg = "yellow" },
	DiagHint = { fg = "gray", bg = "bg" },
	DiagInfo = { fg = "gray", bg = "bg" },
	Ruler = { fg = "bg", bg = "gray" },
	Macro = { fg = "bg", bg = "blue" },
}

function M.setup()
	for key, value in pairs(highlights) do
		local hl_name = "Heirline" .. key
		local custom_hl = utils.get_highlight(hl_name)

		if not custom_hl then
			vim.api.nvim_command("hi def link " .. hl_name .. " " .. value)
		end
	end
end

return M

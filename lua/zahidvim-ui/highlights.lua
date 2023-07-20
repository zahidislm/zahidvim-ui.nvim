local M = {}
local statusline_bg = vim.o.background == "dark" and "#2e323b" or "#bebebe"

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

local function get_hlgroup(name, fallback)
	name = type(name) == "string" and name or ""
	fallback = type(fallback) == "table" and fallback or {}

	local use_fallback = true

	if vim.fn.hlexists(name) == 1 then
		use_fallback = false

		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		hl.fg = not hl.fg and "NONE" or hl.fg
		hl.bg = not hl.bg and "NONE" or hl.bg

		return hl, use_fallback
	end

	return fallback, use_fallback
end

function M.setup()
	for key, value in pairs(highlights) do
		local hl_name = "Heirline" .. key
		local hl_group, use_fallback = get_hlgroup(hl_name, value)

		if use_fallback then
			vim.api.nvim_set_hl(0, hl_name, hl_group)
		end
	end
end

return M

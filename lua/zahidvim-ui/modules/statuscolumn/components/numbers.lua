local M = {}
local icons = vim.g.ui_icons

local function provider_handler()
	local num = vim.v.lnum
	local use_relative = vim.opt.relativenumber._value
	if use_relative and vim.v.relnum ~= 0 then
		num = vim.v.relnum
	end

	local lnum = tostring(num)
	local virtnum = vim.v.virtnum
	local spacer = string.rep(" ", #lnum)

	if virtnum < 0 then
		return spacer
	elseif virtnum > 0 then
		return icons.misc.next_line .. spacer
	else
		return (#lnum == 0 and " " or "") .. lnum
	end
end

function M.setup()
	local component = {
		provider = provider_handler,
		on_click = { name = "line_number_click" },
	}

	return component
end

return M

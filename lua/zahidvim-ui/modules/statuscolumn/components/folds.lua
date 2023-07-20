local M = {}
local icons = vim.g.ui_icons

local function provider_handler()
	local lnum = vim.v.lnum
	local icon = "  "

	if vim.v.virtnum ~= 0 then
		return ""
	end

	if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
		icon = vim.fn.foldclosed(lnum) == -1 and icons.misc.expanded or icons.misc.collapsed
	end

	return icon
end

local function on_click_handler(args)
	local lnum = args.mousepos.line
	if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
		return
	end

	vim.cmd.execute("'" .. lnum .. "fold" .. (vim.fn.foldclosed(lnum) == -1 and "close" or "open") .. "'")
end

function M.setup()
	local component = {
		provider = provider_handler,
		on_click = {
			name = "fold_click",
			callback = function(self, ...)
				on_click_handler(self.click_args(self, ...))
			end,
		},
	}

	return component
end

return M

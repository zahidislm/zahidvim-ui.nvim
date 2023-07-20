local M = {}

function M.init(self)
	self.signs = {}
	local line_diags = vim.fn.sign_getdefined()
	for sign = 1, #line_diags do
		if line_diags[sign].text then
			self.signs[line_diags[sign].text:gsub("%s", "")] = line_diags[sign]
		end
	end
end

function M.static()
	return {
		click_args = function(self, minwid, clicks, button, mods)
			local args = {
				minwid = minwid,
				clicks = clicks,
				button = button,
				mods = mods,
				mousepos = vim.fn.getmousepos(),
			}
			local sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
			sign = sign == " " and vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1) or sign
			args.sign = self.signs[sign]

			vim.api.nvim_set_current_win(args.mousepos.winid)
			vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })

			return args
		end,
	}
end

function M.gitsigns(fallback_hl)
	fallback_hl = type(fallback_hl) == "string" and fallback_hl or "StatusColumnBorder"

	return require("zahidvim-ui.modules.statuscolumn.components.git").setup(fallback_hl)
end

function M.diagnostics()
	return require("zahidvim-ui.modules.statuscolumn.components.diagnostics").setup()
end

function M.line_numbers()
	return require("zahidvim-ui.modules.statuscolumn.components.numbers").setup()
end

function M.folds()
	return require("zahidvim-ui.modules.statuscolumn.components.folds").setup()
end

return M

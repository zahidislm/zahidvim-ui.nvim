local M = {}
local config = require("zahidvim-ui.config")
local icons = require("zahidvim-ui.icons")

function M.setup(opts)
	opts = type(opts) == "table" and opts or {}

	config.setup(opts)
	icons.setup()

	local heirline_installed, heirline = pcall(require, "heirline")

	if heirline_installed then
		heirline.setup(require("zahidvim-ui.components"))
		require("zahidvim-ui.highlights").setup()
	else
		local msg =
			"UI requires 'heirline.nvim' to run. Please add 'heirline.nvim' as a dependancy or install it normally before running UI."
		vim.notify(msg, vim.log.levels.ERROR, { title = "ZahidvimUI" })
	end
end

return M

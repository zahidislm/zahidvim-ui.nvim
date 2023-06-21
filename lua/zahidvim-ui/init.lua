local M = {}

function M.setup(opts)
	opts = type(opts) == "table" and opts or {}

	vim.g.ui_config = require("zahidvim-ui.config").setup(opts)
	vim.g.ui_icons = require("zahidvim-ui.icons").setup()

	local heirline_installed, heirline = pcall(require, "heirline")

	if heirline_installed then
		local heirline_opts = require("zahidvim-ui.components").setup()
		heirline.setup(heirline_opts)
		require("zahidvim-ui.highlights").setup()
	else
		local msg =
			"UI requires 'heirline.nvim' to run. Please add 'heirline.nvim' as a dependancy or install it normally before running UI."
		vim.notify(msg, vim.log.levels.ERROR, { title = "ZahidvimUI" })
	end
end

return M

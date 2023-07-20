local zahidislm_ui = {}
local config = require("zahidvim-ui.config")

function zahidislm_ui.setup(opts)
	opts = type(opts) == "table" and opts or {}

	config.setup(opts)
	vim.g.ui_icons = require("zahidvim-ui.icons").setup()

	local heirline_installed, heirline = pcall(require, "heirline")
	if heirline_installed then
		local heirline_opts = require("zahidvim-ui.modules").setup()
		heirline.setup(heirline_opts)
		if config.options.highlights.enable_fallback then
			require("zahidvim-ui.highlights").setup()
		end
	else
		local msg =
			"UI requires 'heirline.nvim' to run. Please add 'heirline.nvim' as a dependancy or install it normally before running UI."
		vim.notify(msg, vim.log.levels.ERROR, { title = "ZahidvimUI" })
	end
end

return zahidislm_ui

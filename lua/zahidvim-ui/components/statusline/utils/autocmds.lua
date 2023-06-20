local M = {}

local utils = require("heirline.utils")

M.setup = function(highlights)
	highlights = highlights or {}

	do
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(highlights)
			end,
			group = "Heirline",
		})

		local command = "doautocmd User BufEnterOrGitSignsUpdate"
		vim.api.nvim_create_autocmd("BufEnter", { command = command, group = "Heirline" })
		vim.api.nvim_create_autocmd("User", { command = command, group = "Heirline", pattern = "GitSignsUpdate" })
	end
end

return M

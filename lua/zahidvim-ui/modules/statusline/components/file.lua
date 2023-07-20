local M = {}
local icons = vim.g.ui_icons
local config = require("zahidvim-ui.config")
local conds = require("heirline.conditions")
local utils = require("heirline.utils")

local function file_icon()
	return {
		init = function(self)
			local filename = (vim.fn.expand("%") == "" and "Empty ") or vim.fn.expand("%:t")
			local extension = vim.fn.fnamemodify(filename, ":e")
			self.icon = icons.statusline.file

			if config.options.globals.icons.enable_devicons then
				local devicons_installed, dev_icons = pcall(require, "nvim-web-devicons")

				if devicons_installed then
					self.icon = dev_icons.get_icon(filename, extension, { default = true })
				else
					local msg =
						"'nvim-web-devicons' is not installed. Install it, or set use_devicons=false in your configuration to disable this message"
					vim.notify(msg, vim.log.levels.WARN, { title = "ZahidvimUI" })
				end
			end
		end,
		provider = function(self)
			return self.icon and (" " .. self.icon .. " ")
		end,
		hl = M.hls.group,
	}
end

local function ft()
	return {
		provider = function()
			return string.lower(vim.bo.filetype) .. " "
		end,
		hl = M.hls.group,
	}
end

local function file_type()
	local icon = file_icon()
	local filetype = ft()

	return utils.insert(M.slant.right.start, icon, filetype, M.slant.right.close)
end

local function ruler()
	return {
		condition = function(self)
			return not conds.buffer_matches({
				filetype = self.filetypes,
			})
		end,
		{
			provider = icons.statusline.right_slant,
			hl = M.hls.slant_ruler,
		},
		{
			-- %L = number of lines in the buffer
			-- %P = percentage through file of displayed window
			provider = " %P% /%2L ",
			hl = M.hls.ruler,
			on_click = {
				callback = function()
					local line = vim.api.nvim_win_get_cursor(0)[1]
					local total_lines = vim.api.nvim_buf_line_count(0)

					if math.floor((line / total_lines)) > 0.5 then
						vim.cmd("normal! gg")
					else
						vim.cmd("normal! G")
					end
				end,
				name = "heirline_ruler",
			},
		},
	}
end

function M.setup(hls, slant)
	M.hls = type(hls) == "table" and hls or {}
	M.slant = type(slant) == "table" and slant or {}

	M.file_type = file_type()
	M.ruler = ruler()

	return M.file_type, M.ruler
end

return M

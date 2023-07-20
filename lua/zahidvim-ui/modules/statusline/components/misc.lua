local M = {}
local icons = vim.g.ui_icons
local conds = require("heirline.conditions")
local utils = require("heirline.utils")

local function lsp_info()
	return {
		condition = conds.lsp_attached,
		static = {
			lsp_attached = false,
			show_lsps = {
				copilot = false,
				["null-ls"] = false,
			},
		},
		init = function(self)
			for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
				if self.show_lsps[server.name] ~= false then
					self.lsp_attached = true
					self.server_name = server.name
					return
				end
			end
		end,
		update = { "LspAttach", "LspDetach" },
		on_click = {
			callback = function()
				vim.defer_fn(function()
					vim.cmd("LspInfo")
				end, 100)
			end,
			name = "heirline_LSP",
		},
		{
			condition = function(self)
				return self.lsp_attached
			end,
			M.slant.right.start,
			{
				provider = function(self)
					return " " .. icons.statusline.gear .. self.server_name .. " "
				end,
				hl = M.hls.group,
			},
			M.slant.right.close,
		},
	}
end

local function macro()
	return {
		condition = function()
			return vim.fn.reg_recording() ~= ""
		end,
		update = {
			"RecordingEnter",
			"RecordingLeave",
		},
		{
			provider = icons.statusline.right_slant,
			hl = M.hls.slant_inv_macro,
		},
		{
			provider = function()
				return " " .. vim.fn.reg_recording() .. " "
			end,
			hl = M.hls.macro,
		},
		{
			provider = icons.statusline.right_slant,
			hl = M.hls.macro,
		},
	}
end

local function search_results()
	return {
		condition = function()
			return vim.v.hlsearch ~= 0
		end,
		init = function(self)
			local ok, search = pcall(vim.fn.searchcount)
			if ok and search.total then
				self.search = search
			end
		end,
		{
			provider = icons.statusline.right_slant,
			hl = function()
				return { fg = utils.get_highlight("Substitute").bg, bg = "bg" }
			end,
		},
		{
			provider = function(self)
				local search = self.search
				return string.format(" %d/%d ", search.current, math.min(search.total, search.maxcount))
			end,
			hl = function()
				return { bg = utils.get_highlight("Substitute").bg, fg = "bg" }
			end,
		},
		{
			provider = icons.statusline.right_slant,
			hl = function()
				return { bg = utils.get_highlight("Substitute").bg, fg = "bg" }
			end,
		},
	}
end

function M.setup(hls, slant)
	M.hls = type(hls) == "table" and hls or {}
	M.slant = type(slant) == "table" and slant or {}

	M.lsp_info = lsp_info()
	M.macro = macro()
	M.search_results = search_results()

	return M.lsp_info, M.macro, M.search_results
end

return M

local M = {}
local icons = vim.g.ui_icons
local conds = require("heirline.conditions")

local function capitalize(str)
	str = type(str) == "string" and str or ""

	return (str:gsub("^%l", string.upper))
end

local function on_click_integrations()
	local telescope_installed, telescope = pcall(require, "telescope.builtin")

	if telescope_installed then
		telescope.diagnostics({
			layout_strategy = "center",
			bufnr = 0,
		})
	else
		local fzf_installed, fzf = pcall(require, "fzf-lua")

		if fzf_installed then
			fzf.diagnostics_document()
		else
			vim.diagnostic.setqflist()
		end
	end
end

local function builder(signs)
	signs = type(signs) == "table" and signs or {}

	local diag_component = {}

	for pos = 1, #signs do
		local sign = signs[pos]

		diag_component[pos] = {
			condition = function(self)
				return self[sign] > 0
			end,
			hl = M.hls["diag_" .. sign],
			(sign ~= "hint" and sign ~= "info") and {
				provider = icons.statusline.left_slant,
			},
			{
				provider = function(self)
					return " "
						.. vim.fn.sign_getdefined("DiagnosticSign" .. capitalize(sign))[1].text
						.. self[sign]
						.. " "
				end,
			},
			(sign ~= "hint" and sign ~= "info") and {
				provider = icons.statusline.left_slant,
				hl = M.hls["slant_" .. sign],
			},
		}
	end
	return diag_component
end

function M.setup(hls, slant)
	M.hls = type(hls) == "table" and hls or {}
	M.slant = type(slant) == "table" and slant or {}

	local component = {
		condition = conds.has_diagnostics,
		init = function(self)
			self.error = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			self.warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			self.hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
			self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		end,
		on_click = {
			callback = on_click_integrations,
			name = "heirline_diagnostics",
		},
		update = { "DiagnosticChanged", "BufEnter" },
	}

	local diag_component = builder({ "error", "warn", "hint", "info" })
	component = vim.list_extend(component, diag_component)

	return component
end

return M

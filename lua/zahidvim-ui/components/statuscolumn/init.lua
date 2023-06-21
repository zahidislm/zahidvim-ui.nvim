local M = {}
local icons = vim.g.ui_icons

function M.setup(conds, get_hl_func)
	conds = type(conds) == "table" and conds or {}
	get_hl_func = type(get_hl_func) == "function" and get_hl_func or function(hl)
		return hl
	end

	M.static = {
		click_args = function(self, minwid, clicks, button, mods)
			local args = {
				minwid = minwid,
				clicks = clicks,
				button = button,
				mods = mods,
				mousepos = vim.fn.getmousepos(),
			}
			local sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
			if sign == " " then
				sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
			end
			args.sign = self.signs[sign]
			vim.api.nvim_set_current_win(args.mousepos.winid)
			vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })

			return args
		end,
		handlers = {
			diagnostics = function()
				vim.schedule(vim.diagnostic.open_float)
			end,
			git_signs = function()
				vim.schedule(require("gitsigns").preview_hunk)
			end,
			fold = function(args)
				local lnum = args.mousepos.line
				if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
					return
				end
				vim.cmd.execute("'" .. lnum .. "fold" .. (vim.fn.foldclosed(lnum) == -1 and "close" or "open") .. "'")
			end,
		},
	}

	M.init = function(self)
		self.signs = {}
		local line_diags = vim.fn.sign_getdefined()
		for sign = 1, #line_diags do
			if line_diags[sign].text then
				self.signs[line_diags[sign].text:gsub("%s", "")] = line_diags[sign]
			end
		end
	end

	M.git_signs = {
		init = function(self)
			local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
				group = "gitsigns_vimfn_signs_",
				id = vim.v.lnum,
				lnum = vim.v.lnum,
			})

			if #signs == 0 or signs[1].signs == nil or #signs[1].signs == 0 or signs[1].signs[1].name == nil then
				self.sign = nil
			else
				self.sign = signs[1].signs[1]
			end

			self.has_sign = self.sign ~= nil
		end,
		provider = icons.misc.v_border,
		hl = function(self)
			if self.has_sign then
				return self.sign.name
			else
				return get_hl_func("StatusColumnBorder")
			end
		end,
		on_click = {
			name = "gitsigns_click",
			callback = function(self, ...)
				if self.handlers.git_signs then
					self.handlers.git_signs(self.click_args(self, ...))
				end
			end,
		},
	}

	M.diagnostics = {
		init = function(self)
			self.diag_sign = {}
			self.is_git_sign = true

			local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
			local signs = vim.tbl_map(function(sign)
				return vim.fn.sign_getdefined(sign.name)[1]
			end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)

			if next(signs) then
				self.diag_sign = signs[1]

				if not self.diag_sign.name:find("GitSign") then
					self.is_git_sign = false
				end
			end
		end,
		provider = function(self)
			if next(self.diag_sign) and not self.is_git_sign then
				return self.diag_sign.text
			elseif conds.has_diagnostics() then
				return " "
			end
		end,
		hl = function(self)
			if next(self.diag_sign) and not self.is_git_sign then
				return get_hl_func(self.diag_sign.texthl)
			end
		end,
		on_click = {
			name = "diagnostics_click",
			callback = function(self, ...)
				if self.handlers.diagnostics then
					self.handlers.diagnostics(self.click_args(self, ...))
				end
			end,
		},
	}

	M.line_numbers = {
		provider = function()
			local lnum = tostring(vim.v.lnum)
			local virtnum = vim.v.virtnum

			if virtnum < 0 then
				return string.rep(" ", #lnum)
			elseif virtnum > 0 then
				return icons.misc.next_line .. string.rep(" ", #lnum)
			else
				return (#lnum == 0 and " " or "") .. lnum
			end
		end,
		on_click = {
			name = "line_number_click",
			callback = function(self, ...)
				if self.handlers.line_number then
					self.handlers.line_number(self.click_args(self, ...))
				end
			end,
		},
	}

	M.folds = {
		provider = function()
			local lnum = vim.v.lnum
			local icon = "  "

			if vim.v.virtnum ~= 0 then
				return ""
			end

			if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
				if vim.fn.foldclosed(lnum) == -1 then
					icon = icons.misc.expanded
				else
					icon = icons.misc.collapsed
				end
			end

			return icon
		end,
		on_click = {
			name = "fold_click",
			callback = function(self, ...)
				if self.handlers.fold then
					self.handlers.fold(self.click_args(self, ...))
				end
			end,
		},
	}
end

return M

local M = {}

local config = vim.g.ui_config
local icons = vim.g.ui_icons

function M.setup(conds, get_hl_func)
	conds = type(conds) == "table" and conds or {}
	get_hl_func = type(get_hl_func) == "function" and get_hl_func or function(hl)
		return hl
	end

	local highlights = require("zahidvim-ui.components.statusline.utils.colors").setup_highlights()

	--- Redraw the statusline
	local redrawstatus = vim.schedule_wrap(function()
		vim.api.nvim_command("redrawstatus")
	end)

	local left_slant_start = {
		provider = icons.statusline.left_slant,
		hl = highlights.slant_inv,
	}

	local left_slant_end = {
		provider = icons.statusline.left_slant,
		hl = highlights.slant,
	}

	local right_slant_start = {
		provider = icons.statusline.right_slant,
		hl = highlights.slant,
	}

	local right_slant_end = {
		provider = icons.statusline.right_slant,
		hl = highlights.slant_inv,
	}

	---Return the current vim mode
	M.mode = {
		init = function(self)
			self.mode = vim.fn.mode(1)
			self.mode_color = self.mode_colors[self.mode:sub(1, 1)]
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
		static = {
			mode_names = {
				n = "NORMAL",
				no = "NORMAL",
				nov = "NORMAL",
				noV = "NORMAL",
				["no\22"] = "NORMAL",
				niI = "NORMAL",
				niR = "NORMAL",
				niV = "NORMAL",
				nt = "NORMAL",
				v = "VISUAL",
				vs = "VISUAL",
				V = "VISUAL",
				Vs = "VISUAL",
				["\22"] = "VISUAL",
				["\22s"] = "VISUAL",
				s = "SELECT",
				S = "SELECT",
				["\19"] = "SELECT",
				i = "INSERT",
				ic = "INSERT",
				ix = "INSERT",
				R = "REPLACE",
				Rc = "REPLACE",
				Rx = "REPLACE",
				Rv = "REPLACE",
				Rvc = "REPLACE",
				Rvx = "REPLACE",
				c = "COMMAND",
				cv = "Ex",
				r = "...",
				rm = "M",
				["r?"] = "?",
				["!"] = "!",
				t = "TERM",
			},
			mode_colors = require("zahidvim-ui.components.statusline.utils.colors").setup_mode_colors(),
		},
		{
			provider = function(self)
				return " %2(" .. self.mode_names[self.mode] .. "%) "
			end,
			hl = function(self)
				return { fg = "bg", bg = get_hl_func("Heirline" .. self.mode_color).bg }
			end,
		},
		{
			provider = icons.statusline.left_slant,
			hl = function(self)
				return { fg = get_hl_func("Heirline" .. self.mode_color).fg, bg = "bg" }
			end,
		},
	}

	---Return the current git branch in the cwd
	M.git_branch = {
		condition = conds.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
		end,
		update = { "User", callback = redrawstatus, pattern = "BufEnterOrGitSignsUpdate" },
		{
			condition = function(self)
				return not conds.buffer_matches({
					filetype = self.filetypes,
				})
			end,
			left_slant_start,
			{
				provider = function(self)
					return " "
						.. icons.git.branch
						.. (self.status_dict.head == "" and "main" or self.status_dict.head)
						.. " "
				end,
				on_click = {
					callback = function()
						local telescope_installed, telescope = pcall(require, "telescope.builtin")

						if telescope_installed then
							telescope.git_status({ bufnr = 0 })
						else
							local fzf_installed, fzf = pcall(require, "fzf-lua")

							if fzf_installed then
								fzf.git_status()
							else
								require("gitsigns").setqflist()
							end
						end
					end,
					name = "heirline_git_status",
				},
				hl = highlights.group,
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				{
					condition = function(self)
						self.added = self.status_dict.added
						if self.added then
							return self.added > 0
						end
					end,
					provider = function(self)
						return icons.git.status_added .. self.added .. " "
					end,
					hl = highlights.git_added,
				},
				{
					condition = function(self)
						self.changed = self.status_dict.changed
						if self.changed then
							return self.changed > 0
						end
					end,
					provider = function(self)
						return icons.git.status_modified .. self.changed .. " "
					end,
					hl = highlights.git_changed,
				},
				{
					condition = function(self)
						self.removed = self.status_dict.removed
						if self.removed then
							return self.removed > 0
						end
					end,
					provider = function(self)
						return icons.git.status_removed .. self.removed .. " "
					end,
					hl = highlights.git_removed,
				},
			},
			left_slant_end,
		},
	}

	---Return the LspDiagnostics from the LSP servers
	M.lsp_diag = {
		condition = conds.has_diagnostics,
		init = function(self)
			self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
			self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		end,
		on_click = {
			callback = function()
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
			end,
			name = "heirline_diagnostics",
		},
		update = { "DiagnosticChanged", "BufEnter" },
		-- Errors
		{
			condition = function(self)
				return self.errors > 0
			end,
			hl = highlights.diag_error,
			{
				provider = icons.statusline.left_slant,
			},
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignError")[1].text .. self.errors .. " "
				end,
			},
			{
				provider = icons.statusline.left_slant,
				hl = highlights.slant_error,
			},
		},
		-- Warnings
		{
			condition = function(self)
				return self.warnings > 0
			end,
			hl = highlights.diag_warn,
			{
				provider = icons.statusline.left_slant,
			},
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text .. self.warnings .. " "
				end,
			},
			{
				provider = icons.statusline.left_slant,
				hl = highlights.slant_warn,
			},
		},
		-- Hints
		{
			condition = function(self)
				return self.hints > 0
			end,
			hl = highlights.diag_hint,
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignHint")[1].text .. self.hints .. " "
				end,
			},
		},
		-- Info
		{
			condition = function(self)
				return self.info > 0
			end,
			hl = highlights.diag_info,
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text .. self.info .. " "
				end,
			},
		},
	}

	M.lsp_status = {
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
			right_slant_start,
			{
				provider = function(self)
					return " " .. icons.statusline.gear .. self.server_name .. " "
				end,
				hl = highlights.group,
			},
			right_slant_end,
		},
	}

	---Return the current line number as a % of total lines and the total lines in the file
	M.ruler = {
		condition = function(self)
			return not conds.buffer_matches({
				filetype = self.filetypes,
			})
		end,
		{
			provider = icons.statusline.right_slant,
			hl = highlights.slant_ruler,
		},
		{
			-- %L = number of lines in the buffer
			-- %P = percentage through file of displayed window
			provider = " %P% /%2L ",
			hl = highlights.ruler,
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

	M.macro_record = {
		condition = function()
			return vim.fn.reg_recording() ~= ""
		end,
		update = {
			"RecordingEnter",
			"RecordingLeave",
		},
		{
			provider = icons.statusline.right_slant,
			hl = highlights.slant_inv_macro,
		},
		{
			provider = function()
				return " " .. vim.fn.reg_recording() .. " "
			end,
			hl = highlights.macro,
		},
		{
			provider = icons.statusline.right_slant,
			hl = highlights.macro,
		},
	}

	M.search_results = {
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
				return { fg = get_hl_func("Substitute").bg, bg = "bg" }
			end,
		},
		{
			provider = function(self)
				local search = self.search
				return string.format(" %d/%d ", search.current, math.min(search.total, search.maxcount))
			end,
			hl = function()
				return { bg = get_hl_func("Substitute").bg, fg = "bg" }
			end,
		},
		{
			provider = icons.statusline.right_slant,
			hl = function()
				return { bg = get_hl_func("Substitute").bg, fg = "bg" }
			end,
		},
	}

	--- Return information on the current buffers filetype
	local file_icon = {
		init = function(self)
			local filename = (vim.fn.expand("%") == "" and "Empty ") or vim.fn.expand("%:t")
			local extension = vim.fn.fnamemodify(filename, ":e")
			self.icon = icons.statusline.file

			if config.ui.icons.enable_devicons then
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
		hl = highlights.group,
	}

	local file_type = {
		provider = function()
			return string.lower(vim.bo.filetype) .. " "
		end,
		hl = highlights.group,
	}

	M.type_info = require("heirline.utils").insert(right_slant_start, file_icon, file_type, right_slant_end)
end

return M

local M = {}
local conds = require("heirline.conditions")
local icons = vim.g.ui_icons

--- Redraw the statusline for git buffer changes
local redrawstatus = vim.schedule_wrap(function()
	vim.api.nvim_command("redrawstatus")
end)

local function on_click_integrations()
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
end

local function git_component_builder(modes)
	modes = type(modes) == "table" and modes or {}

	local git_component = {
		condition = function(self)
			return self.has_changes
		end,
	}

	for pos = 1, #modes do
		local mode = modes[pos]

		git_component[pos + 1] = {
			condition = function(self)
				self[mode] = self.status_dict[mode]

				if self[mode] then
					return self[mode] > 0
				end
			end,
			provider = function(self)
				return icons.git["status_" .. mode] .. self[mode] .. " "
			end,
			hl = M.hls["git_" .. mode],
		}
	end

	return git_component
end

local function builder()
	local built_component = {
		condition = function(self)
			return not conds.buffer_matches({
				filetype = self.filetypes,
			})
		end,
		M.slant.left.start,
		{
			provider = function(self)
				return " "
					.. icons.git.branch
					.. (self.status_dict.head == "" and "main" or self.status_dict.head)
					.. " "
			end,
			on_click = {
				callback = on_click_integrations,
				name = "heirline_git_status",
			},
			hl = M.hls.group,
		},
	}

	local git_component = git_component_builder({ "added", "changed", "removed" })
	built_component = vim.list_extend(built_component, git_component)
	built_component[#built_component + 1] = M.slant.left.close

	return built_component
end

function M.setup(hls, slant)
	M.hls = type(hls) == "table" and hls or {}
	M.slant = type(slant) == "table" and slant or {}

	local component = {
		condition = conds.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
		end,
		update = { "User", callback = redrawstatus, pattern = "BufEnterOrGitSignsUpdate" },
	}

	local git_component = builder()
	component[#component + 1] = git_component

	return component
end

return M

local M = {}

local listchar_icons = {
	listchars = {
		lead = "·",
		trail = "•",
		extends = "❯",
		precedes = "❮",
		nbsp = "␣",
	},
}

local unicode_icons = {
	diagnostics = {
		Error = "⛒ ",
		Warn = "⚠ ",
		Info = "Ⓘ ",
		Hint = "Ⓗ ",
	},

	git = {
		status_added = "⊕ ",
		status_removed = "⊖ ",
		status_modified = "⊙ ",
		added = "＋",
		deleted = "ｘ",
		modified = "⚬",
		renamed = "↻",
		untracked = "？",
		ignored = "－",
		unstaged = "x ",
		staged = "✓ ",
		conflict = "⤭ ",
		branch = "⑆ ",
	},

	statusline = {
		left_slant = "▌",
		right_slant = "▐",
		gear = "⚙ ",
		file = "🗎 ",
	},

	misc = {
		collapsed = "> ",
		expanded = "∨ ",
		condense = "⇞ ",
		v_border = "│ ",
		select = "▶ ",
		prompt = "⌕ ",
		next_line = "↩ ",
	},
}

local nerdfont_icons = {
	diagnostics = {
		Error = " ",
		Warn = " ",
		Info = " ",
		Hint = " ",
	},

	git = {
		status_added = " ",
		status_removed = " ",
		status_modified = " ",
		added = " ",
		deleted = " ",
		modified = " ",
		renamed = " ",
		untracked = " ",
		ignored = " ",
		unstaged = " ",
		staged = " ",
		conflict = " ",
		branch = " ",
	},

	statusline = {
		left_slant = "",
		right_slant = "",
		gear = " ",
		file = " ",
	},

	misc = {
		collapsed = " ",
		expanded = " ",
		condense = "󰡍 ",
		v_border = "│ ",
		select = " ",
		prompt = " ",
		next_line = "󰌑 ",
	},
}

local function setup_listchars(icons)
	icons = type(icons) == "table" and icons or {}

	local listchars = {}

	if next(icons.listchars) then
		listchars = icons.listchars
	end

	vim.opt.listchars:append(listchars)
end

function M.setup()
	local config = vim.g.ui_config
	local override = config.ui.icons.override or {}
	local icons = unicode_icons

	if config.ui.icons.enable_nerdfont then
		icons = nerdfont_icons
	end

	M.icon_set = vim.tbl_deep_extend("force", icons, listchar_icons, override)

	if config.ui.icons.setup_listchars then
		setup_listchars(M.icon_set)
	end

	return M.icon_set
end

return M

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

	symbol_map = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Copilot = "",
		Codeium = "",
	},

	git = {
		status_added = "⊕ ",
		status_removed = "⊖ ",
		status_changed = "⊙ ",
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
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
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

	symbol_map = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Copilot = "",
		Codeium = "󰘦",
	},

	git = {
		status_added = " ",
		status_removed = " ",
		status_changed = " ",
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
		select = " ",
		prompt = " ",
		next_line = "󰌑 ",
	},
}

local function setup_listchars(icons)
	icons = type(icons) == "table" and icons or {}

	local listchars = next(icons.listchars) and icons.listchars or {}
	vim.opt.listchars:append(listchars)
end

function M.setup()
	local config = require("zahidvim-ui.config")
	local override = config.options.globals.icons.override or {}
	local enabled_icons = config.options.globals.icons.enable_nerdfont and nerdfont_icons or {}

	M.icon_set = vim.tbl_deep_extend("force", unicode_icons, enabled_icons, listchar_icons, override)

	if config.options.globals.icons.setup_listchars then
		setup_listchars(M.icon_set)
	end

	return M.icon_set
end

return M

local config = require("zahidvim-ui.config")

local M = {}

local highlights = {
	slant = "HeirlineSlant",
	slant_inv = "HeirlineSlantInv",
	slant_error = "HeirlineSlantError",
	slant_warn = "HeirlineSlantWarn",
	slant_ruler = "HeirlineSlantRuler",
	slant_inv_macro = "HeirlineSlantInvMacro",
	group = "HeirlineGroup",
	git_added = "HeirlineGitAdded",
	git_changed = "HeirlineGitChanged",
	git_removed = "HeirlineGitRemoved",
	diag_error = "HeirlineDiagError",
	diag_warn = "HeirlineDiagWarn",
	diag_hint = "HeirlineDiagHint",
	diag_info = "HeirlineDiagInfo",
	ruler = "HeirlineRuler",
	macro = "HeirlineMacro",
}

local mode_colors = {
	n = "Magenta",
	i = "Green",
	v = "Orange",
	V = "Orange",
	["\22"] = "Orange",
	c = "Orange",
	s = "Yellow",
	S = "Yellow",
	["\19"] = "Yellow",
	r = "Green",
	R = "Green",
	["!"] = "Red",
	t = "Red",
}

M.setup_highlights = function(colors)
	colors = colors or highlights

	if config.get("statusline").enable_autocmds then
		require("zahidvim-ui.components.statusline.utils.autocmds").setup(colors)
	end

	return colors
end

M.setup_mode_colors = function(colors)
	colors = colors or mode_colors
	return colors
end

return M

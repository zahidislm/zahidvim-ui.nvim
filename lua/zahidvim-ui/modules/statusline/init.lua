local M = {}
local icons = vim.g.ui_icons

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
	ruler = "HeirlineRuler",
	macro = "HeirlineMacro",
}

local slant = {
	left = {
		start = {
			provider = icons.statusline.left_slant,
			hl = highlights.slant_inv,
		},
		close = {
			provider = icons.statusline.left_slant,
			hl = highlights.slant,
		},
	},

	right = {
		start = {
			provider = icons.statusline.right_slant,
			hl = highlights.slant,
		},
		close = {
			provider = icons.statusline.right_slant,
			hl = highlights.slant_inv,
		},
	},
}

---Return the current vim mode
function M.mode()
	return require("zahidvim-ui.modules.statusline.components.mode").setup()
end

-- Return the current git branch in the cwd
function M.git_branch()
	return require("zahidvim-ui.modules.statusline.components.git").setup(highlights, slant)
end

-- Return the LspDiagnostics from the LSP servers
function M.diagnostics()
	return require("zahidvim-ui.modules.statusline.components.diagnostics").setup(highlights, slant)
end

-- Utility tools such as LspInfo, Macro indicator, & search indicator
M.lsp_status, M.macro_record, M.search_results =
	require("zahidvim-ui.modules.statusline.components.misc").setup(highlights, slant)

-- Return information on the current buffer filetype & cursor position
M.file_info, M.ruler = require("zahidvim-ui.modules.statusline.components.file").setup(highlights, slant)

function M.setup_autocmds()
	require("zahidvim-ui.modules.statusline.utils.autocmds").setup(highlights)
end

return M

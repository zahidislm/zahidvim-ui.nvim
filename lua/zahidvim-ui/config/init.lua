local config = {}

config.options = require("zahidvim-ui.config.defaults")

function config.setup(options)
	config.options = vim.tbl_deep_extend("force", config.options, options or {})
	return config.options
end

return config

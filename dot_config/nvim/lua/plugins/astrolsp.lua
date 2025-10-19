---@type LazySpec
return {
	"AstroNvim/astrolsp",
	---@type AstroLSPOpts
	opts = {
		-- customize lsp formatting options
		formatting = {
			disabled = {
				-- disable lua_ls formatting capability to use StyLua to format lua code
				"lua_ls",
			},
		},
	},
}

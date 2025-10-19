---@type LazySpec
return {
	-- Customize catppuccin colorscheme
	{
		"catppuccin",
		---@type CatppuccinOptions
		opts = {
			term_colors = true,
			dim_inactive = { enabled = true },
			styles = {
				conditionals = { "bold", "italic" }, -- expressive flow control
				loops = { "bold" }, -- structural emphasis
				functions = { "bold", "italic" }, -- elegant and distinct
				keywords = { "italic" }, -- refined but subdued
				booleans = { "bold" }, -- logical standouts
				types = { "bold" }, -- consistent with LSP semantics
			},
			lsp_styles = {
				underlines = {
					errors = { "underline", "bold" }, -- clearer distinction for errors
				},
			},
		},
	},

	-- Customize tokyonight colorscheme
	{
		"folke/tokyonight.nvim",
		---@type tokyonight.Config
		opts = {
			style = "night",
			light_style = "day",
			styles = {
				conditionals = { bold = true, italic = true }, -- expressive flow control
				loops = { bold = true }, -- structural emphasis
				functions = { bold = true, italic = true }, -- elegant and distinct
				keywords = { italic = true }, -- refined but subdued
				booleans = { bold = true }, -- logical standouts
				types = { bold = true }, -- consistent with LSP semantics
			},
			dim_inactive = true, -- dims inactive windows
		},
	},
}

---@type LazySpec
return {
	"catppuccin",
	opts = {
		transparent_background = not vim.g.neovide,
		term_colors = true,

		-- Elegant syntax styling: gives distinct hierarchy without visual clutter
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			keywords = { "italic" },
			functions = { "bold" },
			types = { "bold" },
			booleans = { "bold", "italic" },
		},

		-- Modern, non-distracting diagnostic lines (curls look far cleaner than flat lines)
		lsp_styles = {
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
	},
}

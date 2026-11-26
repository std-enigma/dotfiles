---@type LazySpec
return {
	"nvim-neorg/neorg",
	event = "VeryLazy",
	version = "*",
	opts = {
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = "~/Documents/notes",
					},
					default_workspace = "notes",
				},
			},
			["core.journal"] = {
				config = {
					workspace = "notes",
					journal_folder = "40-journal",
					strategy = "nested",
				},
			},
		},
	},
}

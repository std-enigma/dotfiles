---@type LazySpec
return {
	"AstroNvim/astrocommunity",

	-- =========================================================================
	-- Language Packs (LSP, Treesitter, Linters/Formatters)
	-- =========================================================================
	{ import = "astrocommunity.pack.lua" },

	-- =========================================================================
	-- Editing & Text Objects (High-Leverage Motions)
	-- =========================================================================
	{ import = "astrocommunity.motion.mini-ai" },
	{ import = "astrocommunity.motion.nvim-surround" },
	{ import = "astrocommunity.motion.flash-nvim" },

	-- =========================================================================
	-- Navigation, Search & File Management
	-- =========================================================================
	{ import = "astrocommunity.file-explorer.oil-nvim" },
	{ import = "astrocommunity.search.grug-far-nvim" },

	-- =========================================================================
	-- UI & Theme
	-- =========================================================================
	{ import = "astrocommunity.colorscheme.catppuccin" },
	{ import = "astrocommunity.utility.noice-nvim" },
	{ import = "astrocommunity.diagnostics.trouble-nvim" }, -- TODO: remap the default quickfix-list keybindings to use Trouble

	-- =========================================================================
	-- Environment & GUI Integrations
	-- =========================================================================
	{ import = "astrocommunity.recipes.neovide" },
	{ import = "astrocommunity.recipes.vscode" },

	-- =========================================================================
	-- UX & Workflow Tweaks
	-- =========================================================================
	-- Use snacks.nvim for fast, native-feeling LSP picker mappings
	{ import = "astrocommunity.recipes.picker-lsp-mappings" },

	-- Keep buffer clean: diagnostic virtual lines only on current line
	{ import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },
}

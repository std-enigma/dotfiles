---@type LazySpec
return {
	"AstroNvim/astrocommunity",

	-- Language packs
	-- Add lua language pack
	{ import = "astrocommunity.pack.lua" },

	-- Motion
	-- Extend and create a/i textobjects
	{ import = "astrocommunity.motion.mini-ai" },

	-- Easily move selections in any direction
	{ import = "astrocommunity.motion.mini-move" },

	-- Better w/e/b/ge navigation
	{ import = "astrocommunity.motion.nvim-spider" },

	-- Tab out from parentheses, quotes, and similar contexts
	{ import = "astrocommunity.motion.tabout-nvim" },

	-- Add/change/delete surrounding delimiter pairs
	{ import = "astrocommunity.motion.nvim-surround" },

	-- Better % navigation
	{ import = "astrocommunity.motion.vim-matchup" },

	-- Better lsp renaming functionality
	{ import = "astrocommunity.lsp.inc-rename-nvim" },

	-- Colorschemes
	-- Catppuccin colorscheme
	{ import = "astrocommunity.colorscheme.catppuccin" },

	-- Tokyonight colorscheme
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },

	-- Editor
	-- File explorer as a normal buffer
	{ import = "astrocommunity.file-explorer.oil-nvim" },

	-- Better diagnostics + quickfix and location list
	{ import = "astrocommunity.diagnostics.trouble-nvim" },

	-- Find and replace UI
	{ import = "astrocommunity.search.grug-far-nvim" },

	-- Misc
	-- Better UI functionality
	{ import = "astrocommunity.utility.noice-nvim" },

	-- Code chunk highlighting
	{ import = "astrocommunity.indent.snacks-indent-hlchunk" },

	-- Locks some buffers and make them stick
	{ import = "astrocommunity.editing-support.stickybuf-nvim" },

	-- Make split separators colorful with smooth animations
	{ import = "astrocommunity.split-and-window.colorful-winsep-nvim" },

	-- Automatic split window management
	{ import = "astrocommunity.split-and-window.windows-nvim" },

	-- Split/Join code blocks with ease
	{ import = "astrocommunity.editing-support.treesj" },

	-- Smooth window scrolling
	{ import = "astrocommunity.scrolling.vim-smoothie" },

	-- Recipes
	-- Configure nvim for vscode usage
	{ import = "astrocommunity.recipes.vscode" },

	-- Configure nvim for neovide usage
	{ import = "astrocommunity.recipes.neovide" },

	-- Change the looks of heirline.nvim winbar
	{ import = "astrocommunity.recipes.heirline-vscode-winbar" },

	-- Use snacks.nvim for some lsp mappings
	{ import = "astrocommunity.recipes.picker-lsp-mappings" },

	-- Cache and setup the last used colorscheme
	{ import = "astrocommunity.recipes.cache-colorscheme" },
}

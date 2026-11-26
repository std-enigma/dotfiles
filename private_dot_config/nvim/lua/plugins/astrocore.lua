---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Vim options configuration
		options = {
			opt = { -- vim.opt.<key>
				conceallevel = 2, -- conceal formatting
			},
		},
		-- Mappings configuration
		mappings = {
			n = {
				-- navigate buffer tabs
				H = {
					function()
						require("astrocore.buffer").nav(-vim.v.count1)
					end,
					desc = "Previous buffer",
				},
				L = {
					function()
						require("astrocore.buffer").nav(vim.v.count1)
					end,
					desc = "Next buffer",
				},
			},
		},
		-- AutoCmds configuration
		autocmds = {
			-- Hide the tabline when there's only one tab open
			autohidetabline = {
				{
					event = "User",
					pattern = "AstroBufsUpdated", -- triggered when vim.t.bufs is updated
					desc = "Hide tabline when only one buffer and one tab",
					callback = function()
						local new_showtabline = #vim.t.bufs > 1 and 2 or 1
						if new_showtabline ~= vim.opt.showtabline:get() then
							vim.opt.showtabline = new_showtabline
						end
					end,
				},
			},
		},
	},
}

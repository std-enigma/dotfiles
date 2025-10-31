---@diagnostic disable: undefined-field, inject-field
---@type LazySpec
return {
	"folke/flash.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"AstroNvim/astrocore",
			opts = function(_, opts)
				local flash = require("flash")
				local astrocore = require("astrocore")

				opts.mappings = opts.mappings or astrocore.empty_map_table()

				-- Common flash call wrappers
				local function flash_action(fn, desc)
					return { fn, desc = desc }
				end

				local actions = {
					toggle = flash_action(function()
						flash.toggle()
					end, "Toggle Flash Search"),
					jump = flash_action(function()
						flash.jump()
					end, "Flash"),
					remote = flash_action(function()
						flash.remote()
					end, "Remote Flash"),
					treesitter = flash_action(function()
						flash.treesitter()
					end, "Flash Treesitter"),
					treesitter_search = flash_action(function()
						flash.treesitter_search()
					end, "Treesitter Search"),

					hop = flash_action(function()
						---@param o Flash.Format
						local format = function(o)
							return {
								{ o.match.label1, "FlashMatch" },
								{ o.match.label2, "FlashLabel" },
							}
						end

						flash.jump({
							search = { mode = "search" },
							label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
							pattern = [[\<]],
							action = function(match, state)
								state:hide()
								flash.jump({
									search = { max_length = 0 },
									highlight = { matches = false },
									label = { format = format },
									matcher = function(win)
										return vim.tbl_filter(function(m)
											return m.label == match.label and m.win == win
										end, state.results)
									end,
									labeler = function(matches)
										for _, m in ipairs(matches) do
											m.label = m.label2 -- use the second label
										end
									end,
								})
							end,
							labeler = function(matches, state)
								local labels = state:labels()
								for i, match in ipairs(matches) do
									match.label1 = labels[math.floor((i - 1) / #labels) + 1]
									match.label2 = labels[(i - 1) % #labels + 1]
									match.label = match.label1
								end
							end,
						})
					end, "Flash Hop"),
				}

				local maps = {
					n = { gw = actions.hop, s = actions.jump, S = actions.treesitter },
					x = { s = actions.jump, S = actions.treesitter, R = actions.treesitter_search },
					o = { s = actions.jump, r = actions.remote, R = actions.treesitter_search, S = actions.treesitter },
					c = { ["<C-s>"] = actions.toggle },
				}

				opts.mappings = astrocore.extend_tbl(opts.mappings, maps)
			end,
		},
	},
	---@type Flash.Config
	opts = {
		modes = {
			char = {
				jump = { autojump = true },
				keys = { "f", "F", "t", "T" },
				config = function(opts)
					-- autohide flash when in operator-pending mode
					opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

					-- Show jump labels only in operator-pending mode
					opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
				end,
			},
		},
	},
}

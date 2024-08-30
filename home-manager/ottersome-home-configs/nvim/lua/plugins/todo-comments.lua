return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local todo = require("todo-comments")
		todo.setup({
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = "󱛢 ", color = "info" },
				SUPERTODO = { icon = "󱛢 ", color = "info" },
				HACK = { icon = "󱌣 ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				SUPERCHECK = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				TOREM = { icon = "󰃆 ", color = "hint" },
				NOTE = { icon = "󰜎 ", color = "hint" },
				TEST = { icon = "󰙨 ", color = "test" },
				PERF = { icon = "󰜎 ", color = "info" },
				CHECK = { icon = "󰢌 ", color = "warning" },
				DEBUG = { icon = "󰨰 ", color = "hint" },
				DONE = { icon = " ", color = "hint" },
			},
		})
		vim.keymap.set("n", "<leader>td", ":TodoTelescope<CR>", { desc = "Use telescope to pull up todos" })
	end,
}

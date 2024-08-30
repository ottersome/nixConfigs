return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		iron.setup({
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					sh = {
						-- Can be a table or a function that
						-- returns a table (see below)
						command = { "zsh" },
					},
				},
				-- How the repl window will be displayed
				-- See below for more information
				repl_open_cmd = view.split.vertical.botright(100),
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "<space>ic",
				visual_send = "<space>ic",
				send_file = "<space>if",
				send_line = "<space>il",
				send_paragraph = "<space>ip",
				send_until_cursor = "<space>iu",
				send_mark = "<space>im",
				mark_motion = "<space>mc",
				mark_visual = "<space>mc",
				remove_mark = "<space>md",
				cr = "<space>i<cr>",
				interrupt = "<space>rI",
				exit = "<space>iq",
				clear = "<space>cl",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
		})
		vim.keymap.set("n", "<space>ri", "<cmd>IronRepl<cr>")
		vim.keymap.set("n", "<space>rR", "<cmd>IronRestart<cr>")
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		vim.keymap.set("n", "<space>rr", "<cmd>IronSend %reset -f<cr>")
	end,
}

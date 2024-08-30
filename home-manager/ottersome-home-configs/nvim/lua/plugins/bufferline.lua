-- Allows us to see buffers as tabs. Technically not using tabs 😛
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	commit = "73540cb",
	opts = {
		options = {
			separator_style = "slant",
		},
	},
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({})
		--
		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		local function scmd(cmd)
			return function()
				vim.api.nvim_command(cmd)
			end
		end

		keymap.set("n", "<leader>b", ":BufferLinePick<CR>", { desc = "Use BufferLine plugin to pick buffer." }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>-",
			":BufferLinePickClose<CR>",
			{ desc = "Use BufferLine plugin to pick buffer to close." }
		) -- toggle file explorer
		keymap.set("n", "<leader>h",scmd("BufferLineCyclePrev"), { desc = "Bufferline: Go to left tab." }) -- toggle file explorer
		keymap.set("n", "<leader>l",scmd("BufferLineCycleNext"), { desc = "Bufferline: Go to right tab." }) -- toggle file explorer
		keymap.set("n", "<C-h>", scmd("BufferLineMovePrev"), { desc = "Bufferline: Move tab to the left." }) -- toggle file explorer
		keymap.set("n", "<C-l>", scmd("BufferLineMoveNext"), { desc = "Bufferline: Move tab to the right." }) -- toggle file explorer
	end,
}

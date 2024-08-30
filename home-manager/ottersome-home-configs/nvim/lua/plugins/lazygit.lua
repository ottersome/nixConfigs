-- nvim v0.8.0
return {
	event = "VeryLazy",
	"kdheepak/lazygit.nvim",
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local keymap = vim.keymap
		--local lazygit = require("lazygit")
		keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Launch Lazy Git from withing Neovim" })
	end,
}

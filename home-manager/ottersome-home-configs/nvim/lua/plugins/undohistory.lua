return {
	"mbbill/undotree",
	config = function()
		local keymap = vim.keymap
		keymap.set(
			"n",
			"<leader>u",
			":UndotreeToggle<CR>",
			{ noremap = true, silent = true, desc = "Toggle Undo Tree Display" }
		)
	end,
}

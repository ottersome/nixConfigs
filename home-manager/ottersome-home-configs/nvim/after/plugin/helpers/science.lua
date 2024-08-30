-- Helper functions for neovim configuration
-- Will be focused on math equations in markdown
function get_png_from_formula_md()
	--- When handed a position in the buffer it wiill try to find the enclosing dollar symbols and convert it to a png file
	-- Grab the cursor location
	local row_col = vim.api.nvim_win_get_cursor(0)[1]
	-- Look for $ delimters that enclose the current cursor location
	local delim_loc = vim.fn.searchpairpos("$", "", "$", "bn", { line, 0 })
end

local yank_relative_path = function()
	local MiniFiles = require("mini.files")
	local path = MiniFiles.get_fs_entry().path
	vim.fn.setreg('"', vim.fn.fnamemodify(path, ":."))
end

local yank_absolute_path = function()
	local MiniFiles = require("mini.files")
	local path = MiniFiles.get_fs_entry().path
	vim.fn.setreg('"', vim.fn.fnamemodify(path, ":p"))
end
local function to_current_file()
	local MiniFiles = require("mini.files")
	MiniFiles.open(vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", "gy", yank_relative_path, { desc = "Yank relative path", buffer = args.data.buf_id })
		vim.keymap.set("n", "gY", yank_absolute_path, { desc = "Yank absolute path", buffer = args.data.buf_id })
	end,
})

return {
	"echasnovski/mini.files",
	version = "*",
	config = function()
		local minifiles = require("mini.files").setup({
			-- Customization of shown content
			content = {
				-- Predicate for which file system entries to show
				filter = nil,
				-- What prefix to show to the left of file system entry
				prefix = nil,
				-- In which order to show file system entries
				sort = nil,
			},

			-- Module mappings created only inside explorer.
			-- Use `''` (empty string) to not create one.
			mappings = {
				get_relative_path = "\\",
				close = "q",
				go_in = "l",
				go_in_plus = "L",
				go_out = "h",
				go_out_plus = "H",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = true,
				-- Whether to use for editing directories
				use_as_default_explorer = true,
			},

			-- Customization of explorer windows
			windows = {
				-- Maximum number of windows to show side by side
				max_number = math.huge,
				-- Whether to show preview of file/directory under cursor
				preview = true,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 50,
			},
		})
	end,

	vim.keymap.set("n", "<leader>ee", to_current_file, { desc = "Minifiles: Open in Current File" }),
	vim.keymap.set("n", "<leader>er", ":lua MiniFiles.open()<CR>", { desc = "Minifiles: Open" }),
}

return {
	"sindrets/diffview.nvim",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>xv", ":DiffviewOpen<CR>", { desc = "View DiffView Window" })
		keymap.set(
			"n",
			"<leader>xx",
			":DiffviewOpen HEAD -- %<CR>",
			{ desc = "View Differences between this file in head and unstaged version." }
		)
		-- Lua
		local actions = require("diffview.actions")

		require("diffview").setup({
			diff_binaries = false, -- Show diffs for binaries
			enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
			git_cmd = { "git" }, -- The git executable followed by default args.
			hg_cmd = { "hg" }, -- The hg executable followed by default args.
			use_icons = true, -- Requires nvim-web-devicons
			show_help_hints = true, -- Show hints for how to open the help panel
			watch_index = true, -- Update views and index buffers when the git index changes.
			icons = { -- Only applies when use_icons is true.
				folder_closed = "",
				folder_open = "",
			},
			signs = {
				fold_closed = "",
				fold_open = "",
				done = "✓",
			},
			view = {
				-- Configure the layout and behavior of different types of views.
				-- Available layouts:
				--  'diff1_plain'
				--    |'diff2_horizontal'
				--    |'diff2_vertical'
				--    |'diff3_horizontal'
				--    |'diff3_vertical'
				--    |'diff3_mixed'
				--    |'diff4_mixed'
				-- For more info, see |diffview-config-view.x.layout|.
				default = {
					-- Config for changed files, and staged files in diff views.
					layout = "diff2_horizontal",
					disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
					winbar_info = false, -- See |diffview-config-view.x.winbar_info|
				},
				merge_tool = {
					-- Config for conflicted files in diff views during a merge or rebase.
					layout = "diff3_mixed",
					disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
					winbar_info = true, -- See |diffview-config-view.x.winbar_info|
				},
				file_history = {
					-- Config for changed files in file history views.
					layout = "diff2_horizontal",
					disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
					winbar_info = false, -- See |diffview-config-view.x.winbar_info|
				},
			},
			file_panel = {
				listing_style = "tree", -- One of 'list' or 'tree'
				tree_options = { -- Only applies when listing_style is 'tree'
					flatten_dirs = true, -- Flatten dirs that only contain one single dir
					folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
				},
				win_config = { -- See |diffview-config-win_config|
					position = "left",
					width = 35,
					win_opts = {},
				},
			},
			file_history_panel = {
				log_options = { -- See |diffview-config-log_options|
					git = {
						single_file = {
							diff_merges = "combined",
						},
						multi_file = {
							diff_merges = "first-parent",
						},
					},
					hg = {
						single_file = {},
						multi_file = {},
					},
				},
				win_config = { -- See |diffview-config-win_config|
					position = "bottom",
					height = 16,
					win_opts = {},
				},
			},
			commit_log_panel = {
				win_config = {}, -- See |diffview-config-win_config|
			},
			default_args = { -- Default args prepended to the arg-list for the listed commands
				DiffviewOpen = {},
				DiffviewFileHistory = {},
			},
		})
	end,
}

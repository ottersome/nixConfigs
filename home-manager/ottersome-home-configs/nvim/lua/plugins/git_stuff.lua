return {
	--TODO: Bring other git-related plugins into this file
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")
		local map = vim.keymap.set

		-- Mappings
		map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "GitDiff: Stage Hunk" })
		map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "GitDiff: Reset Hunk" })
		map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "GitDiff: Stage Buffer" })
		map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "GitDiff: Undo Stage Hunk" })
		-- map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "GitDiff: Reset Buffer" })
		map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "GitDiff: Preview Hunk" })
		map("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "GitDiff: Blame Line" })
		map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "GitDiff: Toggle Cur Blame Line" })
		map("n", "<leader>gd", gitsigns.diffthis, { desc = "GitDiff: Diff This" })
		map("n", "<leader>gD", function()
			gitsigns.diffthis("~", { desc = "GitDiff: ~ Diff This" })
		end)
		-- Visual mappings
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "GitDiff: Stage Hunk" })
		end)
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "GitDiff: Rest Hunk" })
		end)
		map("n", "<leader>gtd", gitsigns.toggle_deleted, { desc = "GitDiff: Toggle Deleted" })

		-- Do setup
		gitsigns.setup({
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[g", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)
			end,
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			-- current_line_blame_formatter_opts = {
			-- 	relative_time = false,
			-- },
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})
	end,
}

return {
	{
		event = "VeryLazy",
		"folke/noice.nvim",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local noice = require("noice")
			noice.setup({})
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Outline: Toggle" })

			require("outline").setup({
				-- Your setup opts here (leave empty to use defaults)
				outline_items = {
					show_symbol_lineno = true,
				},
				outline_window = {
          position = 'left',
					width = 20,

				},
        symbols = {
          filter = { 'String', 'Variable', exclude=true},
        },
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			local notify = require("notify")
			vim.notify = notify
			vim.keymap.set("n", "<leader>nd", function()
				require("notify").dismiss()
			end, { desc = "Notify: Dismiss" })
		end,
	},
	{
		"shortcuts/no-neck-pain.nvim",
		event = "VeryLazy",
		config = function()
			require("no-neck-pain").setup({
				width = 180,
			})
			vim.keymap.set("n", "<leader>nn", ":NoNeckPain<CR>", { desc = "NoNeckPain: Toggle" })
		end,
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			local fidget = require("fidget")
			fidget.setup({
				progress = {
					poll_rate = 0, -- How and when to poll for progress messages
					suppress_on_insert = false, -- Suppress new messages while in insert mode
					ignore_done_already = false, -- Ignore new tasks that are already complete
					ignore_empty_message = false, -- Ignore new tasks that don't contain a message
					-- Clear notification group when LSP server detaches
					clear_on_detach = function(client_id)
						local client = vim.lsp.get_client_by_id(client_id)
						return client and client.name or nil
					end,
					-- How to get a progress message's notification group key
					notification_group = function(msg)
						return msg.lsp_client.name
					end,
					ignore = {}, -- List of LSP servers to ignore

					-- Options related to how LSP progress messages are displayed as notifications
					display = {
						render_limit = 16, -- How many LSP messages to show at once
						done_ttl = 5, -- How long a message should persist after completion
						done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
						done_style = "Constant", -- Highlight group for completed LSP tasks
						progress_ttl = math.huge, -- How long a message should persist when in progress
						-- Icon shown when LSP progress tasks are in progress
						progress_icon = { pattern = "dots", period = 1 },
						-- Highlight group for in-progress LSP tasks
						progress_style = "WarningMsg",
						group_style = "Title", -- Highlight group for group name (LSP server name)
						icon_style = "Question", -- Highlight group for group icons
						priority = 30, -- Ordering priority for LSP notification group
						skip_history = true, -- Whether progress notifications should be omitted from history
						-- How to format a progress message
						format_message = require("fidget.progress.display").default_format_message,
						-- How to format a progress annotation
						format_annote = function(msg)
							return msg.title
						end,
						-- How to format a progress notification group's name
						format_group_name = function(group)
							return tostring(group)
						end,
						overrides = { -- Override options from the default notification config
							rust_analyzer = { name = "rust-analyzer" },
						},
					},

					-- Options related to Neovim's built-in LSP client
					lsp = {
						progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
					},
				},
				notification = {
					poll_rate = 10, -- How frequently to poll and render notifications
					filter = vim.log.levels.WARN, -- Minimum notifications level
					override_vim_notify = true, -- Automatically override vim.notify() with Fidget
					-- How to configure notification groups when instantiated
					--configs = { default = M.default_config },
					-- How to configure notification groups when instantiated
					configs = { default = require("fidget.notification").default_config },

					-- Options related to how notifications are rendered as text
					view = {
						stack_upwards = true, -- Display notification items from bottom to top
						icon_separator = " ", -- Separator between group name and icon
						group_separator = "---", -- Separator between notification groups
						-- Highlight group used for group separator
						group_separator_hl = "Comment",
					},
					-- Conditionally redirect notifications to another backend
					redirect = function(msg, level, opts)
						if opts and opts.on_open then
							return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
						end
					end,

					-- Options related to the notification window and buffer
					window = {
						normal_hl = "Comment", -- Base highlight group in the notification window
						winblend = 100, -- Background color opacity in the notification window
						border = "none", -- Border around the notification window
						zindex = 45, -- Stacking priority of the notification window
						max_width = 0, -- Maximum width of the notification window
						max_height = 0, -- Maximum height of the notification window
						x_padding = 1, -- Padding from right edge of window boundary
						y_padding = 0, -- Padding from bottom edge of window boundary
						align = "top", -- Whether to bottom-align the notification window
						relative = "editor", -- What the notification window position is relative to
					},
				},

				integration = {
					["nvim-tree"] = {
						enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
					},
				},
			})
		end,
	},
	-- {
	-- 	"chentoast/marks.nvim",
	-- 	config = function()
	-- 		local marks = require("marks")
	-- 		marks.setup({
	-- 			default_mappings = true,
	-- 			-- which builtin marks to show. default {}
	-- 			builtin_marks = { ".", "<", ">", "^" },
	-- 			-- whether movements cycle back to the beginning/end of buffer. default true
	-- 			cyclic = true,
	-- 			-- whether the shada file is updated after modifying uppercase marks. default false
	-- 			force_write_shada = false,
	-- 			-- how often (in ms) to redraw signs/recompute mark positions.
	-- 			-- higher values will have better performance but may cause visual lag,
	-- 			-- while lower values may cause performance penalties. default 150.
	-- 			refresh_interval = 250,
	-- 			-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
	-- 			-- marks, and bookmarks.
	-- 			-- can be either a table with all/none of the keys, or a single number, in which case
	-- 			-- the priority applies to all marks.
	-- 			-- default 10.
	-- 			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	-- 			-- disables mark tracking for specific filetypes. default {}
	-- 			excluded_filetypes = {},
	-- 			-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
	-- 			-- sign/virttext. Bookmarks can be used to group together positions and quickly move
	-- 			-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
	-- 			-- default virt_text is "".
	-- 			bookmark_0 = {
	-- 				sign = "⚑",
	-- 				virt_text = "hello world",
	-- 				-- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
	-- 				-- defaults to false.
	-- 				annotate = false,
	-- 			},
	-- 			mappings = {},
	-- 		})
	-- 	end,
	-- },
	{ --TOREM: Might want to remove this
		-- For theminimap
		"gorbit99/codewindow.nvim",
		event = "VeryLazy",
		config = function()
			local codewindow = require("codewindow")
			codewindow.setup({})
			-- codewindow.apply_default_keybinds()
			local keymap = vim.keymap
			keymap.set("n", "<leader>mi", function()
				codewindow.toggle_minimap()
			end, { desc = "CodeWindow: Toggle" })
			keymap.set("n", "<leader>mf", function()
				codewindow.toggle_minimap()
			end, { desc = "CodeWindow: Toggle" })
			vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = "NONE" })
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		config = function()
			local scrollbar = require("scrollbar")
			scrollbar.setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "VeryLazy",
		opts = {},
		setup = function()
			require("ibl").setup({})
		end,
	},
	{
		event = "VeryLazy",
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true, -- or `opts = {}`
	},
	{
		"preservim/vimux",
	},
	{
		"declancm/cinnamon.nvim",
		version = "*", -- use latest release
		opts = {
			-- change default options here
		},
		config = function()
			require("cinnamon").setup({
				-- Enable all provided keymaps
				keymaps = {
					basic = true,
					-- extra = true,
				},
				-- Only scroll the window
				options = {
					mode = "window",
					max_delta = {
						line = 100,
						time = 500,
					},
				},
			})
		end,
	},
}

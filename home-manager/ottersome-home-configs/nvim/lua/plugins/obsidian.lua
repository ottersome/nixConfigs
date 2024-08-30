return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		"BufReadPre "
			.. vim.fn.expand("~")
			.. "/Documents/LeVault/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Documents/LeVault/**.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Documents/LeVault",
			},
		},
		-- see below for full list of options 👇
		attachments = {
			-- img_folder = ,
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "telescope.nvim",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
		},
		follow_url_func = function(url)
			-- Open the URL in the default web browser.
			-- vim.fn.jobstart({ "open", url }) -- Mac OS
			-- vim.fn.jobstart({ "xdg-open", url, "&", "disown" }) -- linux
			vim.fn.jobstart({ "xdg-open", url }) -- linux
		end,
		templates = {
			folder = "Templates",
			date_format = "YYYY-MM-DD",
			time_format = "HH-mm",
			-- date_format = "%Y-%m-%d",
			-- time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "DailyNotes",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d-%A",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "obsidian-daily-note-template",
		},
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
	},
}

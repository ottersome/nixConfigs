return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")
		local home_var = vim.env.HOME

		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				graphql = { "prettier" },
				html = { "prettier" },
				java = { "uncrustify" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				python = { "isort", "black" },
				svelte = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				yaml = { "prettier" },
        go = { "gofmt" },
			},
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 1000,
			-- },
			formatters = {
				uncrustify = {
					env = {
						UNCRUSTIFY_CONFIG = home_var .. "/.config/uncrustify/uncrustify.cfg",
					},
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>z", function()
			conform.format({
				lsp_fallback = true,
				async = true,
				timeout_ms = 1000,
			})
		end, { desc = "Conform: Format file or range (in visual mode)" })
	end,
}

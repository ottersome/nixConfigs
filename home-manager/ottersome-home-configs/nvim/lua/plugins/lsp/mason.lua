return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
        "bashls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})
    -- require("mason-lspconfig").setup_handlers {
    --   function (server_name)
    --     require("lspconfig")[server_name].setup{}
    --   end,
    --   -- Next, you can provide a dedicated handler for specific servers.
    --   -- For example, a handler override for the `rust_analyzer`:
    --   -- ["rust_analyzer"] = function ()
    --   --     require("rust-tools").setup {}
    --   -- end
    -- }

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				-- "black", -- python formatter
				-- "pylint", -- python linter
        "ruff-lsp",
				"eslint_d", -- js linter
			},
		})
	end,
}

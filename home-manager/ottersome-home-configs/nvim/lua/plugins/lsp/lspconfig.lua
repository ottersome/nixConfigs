return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"kevinhwang91/promise-async", -- Dependency form nvim-ufo here
		-- "kevinhwang91/nvim-ufo", -- Not much a dependency but something we want configed in the same place
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- Setup nvim-lspconfig

		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- TOREM: Probably ufo
		-- Setup up UFO (for folding)
		-- vim.o.foldcolumn = "1" -- '0' is not bad
		-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		-- vim.o.foldlevelstart = 99
		-- vim.o.foldenable = false
		-- vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		-- require("ufo").setup()

		--Set lsp log level to info

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local opts = { noremap = true, silent = true }
		local on_attach = function(_, bufnr)
			local function buf_set_option(...)
				vim.api.nvim_buf_set_option(bufnr, ...)
			end
			opts.buffer = bufnr
			buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
			-- Send notifaction saying we have attached
			local keymap = vim.keymap -- for conciseness

			-- set keybinds
			opts.desc = "Show LSP references"
			opts.desc = "Telescope: Go to references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			-- opts.desc = "Go to declaration"
			-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Open definition in a vertical split"
			keymap.set("n", "gvd", "<cmd>lua vim.lsp.buf.definition()<CR><C-w>v", opts) -- open definition in vertical split

			opts.desc = "Open definition in a horizontal split"
			keymap.set("n", "gsd", "<cmd>lua vim.lsp.buf.definition()<CR><C-w>v", opts) -- open definition in vertical split

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>L", vim.diagnostic.open_float, opts) -- show diagnostics for line

			-- These should be enabled bu default
			-- opts.desc = "Go to previous diagnostic"
			-- keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
			--
			-- opts.desc = "Go to next diagnostic"
			-- keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
		-- vim.lsp.set_log_level("debug")
		vim.lsp.set_log_level("WARN")
    local util = require("lspconfig.util")

		-- lspconfig["nil_ls"].setup({
  --     cmd = {"nil"},
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
  --     filetypes = { 'nix' },
  --     single_file_support = true,
  --     root_dir = util.root_pattern('flake.nix', '.git'),
		-- })
		lspconfig["nil_ls"].setup({
			cmd = {"nil"},
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})
		lspconfig["texlab"].setup({
      cmd = { 'texlab' },
			-- capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})
		lspconfig["ruff_lsp"].setup({
      cmd = { 'ruff-lsp' },
			-- capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})
		lspconfig["pyright"].setup({
			cmd = { "pyright-langserver", "--stdio" },
			capabilities = capabilities,
			on_attach = on_attach,
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          -- See: https://github.com/microsoft/pyright/blob/main/docs/configuration.md
          disableOrganizeImports = true,
        },
      ignore = { '*' },
        -- python = {
        --   analysis = {
        --     -- Ignore all files for analysis to exclusively use Ruff for linting
        --   },
        -- },
      },
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})
		lspconfig["clangd"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})
		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
		})

		-- Configure texlab
		lspconfig["texlab"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(fname) --TODO: dont know if I want to change this to someting that looks at .git
				return vim.fn.getcwd()
			end,
			settings = {
				texlab = {
					auxDirectory = ".",
					bibtexFormatter = "texlab",
					build = {
						executable = "xelatex",
						-- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
						forwardSearchAfter = false,
						onSave = false,
					},
					chktex = {
						onEdit = false,
						onOpenAndSave = false,
					},
					diagnosticsDelay = 300,
					formatterLineLength = 80,
					forwardSearch = {
						args = {},
					},
					latexFormatter = "latexindent",
					latexindent = {
						modifyLineBreaks = false,
					},
				},
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
}

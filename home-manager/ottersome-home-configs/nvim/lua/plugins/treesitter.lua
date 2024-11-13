
local function scmd(cmd)
	return function()
		vim.api.nvim_command(cmd)
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- "windwp/nvim-ts-autotag",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = {
					enable = true,
				},
				-- ensure these language parsers are installed
				ensure_installed = {
					"bash",
					"css",
					"dockerfile",
					"gitignore",
					"go",
					"graphql",
					"html",
					"java",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"prisma",
					"python",
					"query",
					"svelte",
					"tsx",
					"typescript",
					"vim",
					"yaml",
          "cpp",
          "dockerfile",
          "nix",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "]x",
						node_incremental = "]x",
						node_decremental = "[x",
						scope_incremental = "]z",
						-- scope_decremental = "<bs>",
					},
				},
				-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
			-- Tree-sitter based folding
			require("nvim-treesitter.configs").setup({
				-- One of "all", "comment", "none"
				fold_by_default = "none",
				-- Whether to fold comments by default
				fold_comments = true,
				-- Whether to fold semantic (new lines) by default
				fold_semantic = true,
				-- Whether to fold text objects (new lines) by default
				fold_text_objects = true,
				-- Whether to fold the indent of the cursor line by default
				fold_indent = true,
				-- Whether to fold treesitter nodes by default
				fold_nodes = true,
				-- Whether to fold code block by default
				fold_code_blocks = true,
				-- Whether to fold yaml nodes by default
				fold_yaml = true,
				-- Whether to fold HTML nodes by default
				fold_html = true,
				-- Whether to fold markdown nodes by default
				fold_markdown = true,
			})
			-- Set fold method to "expr" for treesitter based folding
			vim.cmd([[set foldmethod=expr]])
			vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])
      vim.o.foldlevel = 99

      -- vim.keymap.set("n","<leader>Ze", scmd("set foldexpr=nvim_treesitter#foldexpr()")
			-- vim.g.foldmethod = "expr"
			-- vim.g.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
	{
		-- Depends on above.
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local ntt = require("nvim-treesitter.configs")
			ntt.setup({
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = { query = "@function.outer", desc = "TSTO: Next func start" },
							["]w"] = { query = "@class.outer", desc = "TSTO: Next class start" },
							--
							-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
							-- LG: Not sure what this does
							-- ["]o"] = "@loop.*",
							-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
							--
							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							--
							-- Seems like it isnt working
							["]b"] = { query = "@block.inner", desc = "TSTO: Next block" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "TSTO: Next fold" },
						},
						goto_next_end = {
							["]F"] = { query = "@function.outer", desc = "TSTO: N/ func out end" },
							["]W"] = { query = "@class.outer", desc = "TSTO: N/ class out end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@function.outer", desc = "TSTO: P/ func out start" },
							["[w"] = { query = "@class.outer", desc = "TSTO: P/ class out start" },
							-- Seems like it isnt working
							["[b"] = { query = "@block.inner", desc = "TSTO: Previous block" },
						},
						goto_previous_end = {
							["[F"] = { query = "@function.outer", desc = "TSTO: P/ func out end" },
							["[W"] = { query = "@class.outer", desc = "TSTO: P/ class out end" },
						},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						-- goto_next = {
						-- 	["]d"] = "@conditional.outer",
						-- },
						-- goto_previous = {
						-- 	["[d"] = "@conditional.outer",
						-- },
					},
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "TSTO: Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["ab"] = {
								query = "@block.inner",
								desc = "TSTO: Select inner part of a block region",
							},
							["aB"] = {
								query = "@block.outer",
								desc = "TSTO: Select inner part of a block region",
							},
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "V", -- linewise
							-- ["@class.outer"] = "<c-v>", -- blockwise
						},
					},
				},
			})
		end,
	},
}

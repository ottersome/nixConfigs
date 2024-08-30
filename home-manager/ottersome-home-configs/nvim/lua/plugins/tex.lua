return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	config = function()
		-- VimTeX configuration goes here
		vim.g.vimtex_view_method = "sioyek"
		-- vim.g.maplocalleader = ";"

		-- vim.g.vimtex_compiler_method = "latexrun"
	end,
}

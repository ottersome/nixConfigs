return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},
	-- For closing pairs
	-- {
	-- 	"echasnovski/mini.pairs",
	-- 	version = "*",
	-- 	config = function()
	-- 		require("mini.pairs").setup()
	-- 	end,
	-- },
	-- For getting colors to show. Useful but not always
	-- {
	--   'norcalli/nvim-colorizer.lua',
	--   config = function()
	--     require("colorizer").setup()
	--   end
	--
	-- }
}

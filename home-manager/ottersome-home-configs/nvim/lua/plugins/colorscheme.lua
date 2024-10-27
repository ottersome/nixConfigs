return {
	{ "rebelot/kanagawa.nvim" },
	{
		"nordtheme/vim",
		name = "nord",
		--config = function()
		--vim.cmd([[colorscheme nord]])
		--end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		-- config = function()
		-- 	require("nordic").load()
		-- end,
	},
  {"fcancelinha/nordern.nvim"},
  {"yorumicolors/yorumi.nvim"}, -- Dark colorscheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
  { "ellisonleao/gruvbox.nvim", config = true, opts = ...},
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"AlessandroYorba/Alduin",
		name = "alduin",
	},
  {"sainnhe/everforest",
		config = function()
			vim.g.alduin_Shout_Dragon_Aspect = true
			vim.cmd([[colorscheme everforest]])
		end,
  },
  {"sainnhe/gruvbox-material"}
	-- { "jdsimcoe/abstract.vim" },
}

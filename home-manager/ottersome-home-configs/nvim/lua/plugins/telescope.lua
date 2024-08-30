return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.3",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		local ts = require("telescope")
		ts.setup({
			defaults = {
				layout_strategy = "flex",
				layout_config = {
					flex = {
						flip_columns = 140,
						horizontal = {
							preview_width = function(_, cols, _)
								if cols > 140 then
									return math.floor(cols * 0.4)
								else
									return math.floor(cols * 0.6)
								end
							end,
						},
						vertical = {
							preview_height = function(_, _, rows)
								return math.floor(rows * 0.5)
							end,
						},
					},
				},
			},
		})
	end,
}

local get_python_path = function()
	local python_bin = vim.fn.system("poetry run which python")
	if not python_bin:find("pypoetry") then
		--Print Notify Warn
		vim.notify("Possibly using global python for debug", vim.log.levels.ERROR, { title = "DAP" })
	end
	--Turn python_bin to string
	python_bin = python_bin:gsub("\n", "")
	return python_bin
end
local enrich_config = function(config, on_config)
	if not config.pythonPath and not config.python then
		config.pythonPath = get_python_path()
	end
	on_config(config)
end
-- Create Function That returns DebugPy Configurationa as we do below
local function load_debugpy_config(dap, python_bin)
	-- Configure adapter
	dap.adapters.python = function(cb, config)
		if config.request == "attach" then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
			local host = (config.connect or config).host or "127.0.0.1"
			cb({
				type = "server",
				port = assert(port, "`connect.port` is required for a python `attach` configuration"),
				host = host,
				enrich_config = enrich_config,
				options = {
					source_filetype = "python",
				},
			})
		else
			cb({
				type = "executable",
				-- command = python_bin,
				command = "/home/ottersome/.cache/pypoetry/virtualenvs/lam-MhaQ3mHR-py3.12/bin/python",
				args = { "-m", "debugpy.adapter" },
				enrich_config = enrich_config,
				options = {
					source_filetype = "python",
				},
			})
		end
	end

	-- Check if there are any debugpy configurations in path tree
	local debugpy_config = vim.fn.globpath(vim.fn.getcwd(), "launch.json", true)
	-- Get deepest🥵 config
	if debugpy_config ~= "" then -- Setup Default Config
		debugpy_config = vim.fn.split(debugpy_config, "\n")
		debugpy_config = debugpy_config[#debugpy_config]
		-- Print to user debugpy_config for debugging
		require("dap.ext.vscode").load_launchjs(debugpy_config)
	else
		debugpy_config = {
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				return python_bin
			end,
		}
		-- Python Configruations
		dap.configurations.python = {
			debugpy_config,
		}
	end
end

local function run_line()
	-- Will run currently highlighted line in repl
	-- Extract current line under cursor in buffer into cur_line
	local cur_line = vim.fn.getline(".")
	vim.notify("Repl Running: " .. cur_line, "info", { title = "DAP" })
	local replp = require("dap.repl")
	replp.execute(cur_line)
end

return {
	{
		--"puremourning/vimspector",
		--TODO: possibly lazy load this better
		"mfussenegger/nvim-dap",
		config = function()
			local keymap = vim.keymap

			local dap = require("dap")

			-- use run_line()
			keymap.set("n", "<leader>de", run_line, { desc = "DAP: (E)valuate Line" })

			keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP: Continue" })
			keymap.set("n", "<leader>dC", "<cmd>lua require'dap'.run_last()<CR>", { desc = "DAP: Run Last" })
			keymap.set("n", "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP: Step Over" })
			keymap.set("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP: Step Into" })
			keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP: Step Out" })
			keymap.set(
				"n",
				"<leader>db",
				"<cmd>lua require'dap'.toggle_breakpoint()<CR>",
				{ desc = "DAP: Toggle Breakpoint" }
			)
			keymap.set(
				"n",
				"<leader>dB",
				"<cmd>lua require'dap'.clear_breakpoints()<CR>",
				{ desc = "DAP: Clear Breakpoints" }
			)
			keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.restart()<CR>", { desc = "DAP: Restart" })
			--keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "DAP: REPL toggle" })
			keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "DAP: Run Last" })
			keymap.set("n", "<leader>dv", "<cmd>lua require'dap.ui.variables'.hover()<CR>", { desc = "DAP: Variables" })

			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "DAP: View Value of expression under cursor in floatwin" })
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end, { desc = "DAP: Preview Widgets" })
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { desc = "DAP: Centered Frames Widgets" })
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "DAP: View Variables in Scope" })
			-- Terminate current session
			vim.keymap.set("n", "<Leader>dt", function()
				require("dap").disconnect()
				require("dap").close()
			end, { desc = "DAP: Terminate Session" })

			local python_bin = vim.fn.system("readlink -f $(which python)")

			-- Im no longer exclusive to conda:
			-- if not python_bin:find("miniconda") then
			-- 	--Print Warning in Red
			-- 	vim.cmd("echohl WarningMsg")
			-- 	vim.cmd('echomsg "Warning: Possibly using global python"')
			-- 	vim.cmd("echohl None")
			-- end
			-- --Turn python_bin to string
			-- python_bin = python_bin:gsub("\n", "")

			-- Dyanamically Load DebugPy Config
			load_debugpy_config(dap, python_bin)

			--END Function
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dapui = require("dapui")
			dapui.setup({})
			local keymap = vim.keymap

			keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", { desc = "DAP-UI: Show DAP UI" })
			keymap.set("n", "<leader>dm", "<cmd>lua require('dapui').eval()<CR>", { desc = "DAP-UI: Show DAP UI" })
		end,
	},
	{ -- Virtual Text Gives you Values of Variables while you debug
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			local virttext = require("nvim-dap-virtual-text")
			virttext.setup({})
		end,
	},
	{
		-- {
		-- 	"benlubas/molten-nvim",
		-- 	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		-- 	dependencies = { "3rd/image.nvim" },
		-- 	build = ":UpdateRemotePlugins",
		-- 	init = function()
		-- 		-- these are examples, not defaults. Please see the readme
		-- 		vim.g.molten_image_provider = "image.nvim"
		-- 		vim.g.molten_output_win_max_height = 20
		-- 	end,
		-- },
		-- {
		-- 	-- see the image.nvim readme for more information about configuring this plugin
		-- 	"3rd/image.nvim",
		-- 	opts = {
		-- 		backend = "ueberzug", -- whatever backend you would like to use
		-- 		max_width = 100,
		-- 		max_height = 12,
		-- 		max_height_window_percentage = math.huge,
		-- 		max_width_window_percentage = math.huge,
		-- 		window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
		-- 		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		-- 	},
		-- },
	},
}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function dewrap()
	-- Basically just replace every stopping point ".". With  Stopping point followed by break line
end

local function scmd(cmd)
	return function()
		vim.api.nvim_command(cmd)
	end
end

local keymap = vim.keymap
-- My lovelies:
-- keymap.set("n", "<leader>s", ":silent update<CR>", { desc = "Update file" })
keymap.set("n", "<leader>s", scmd("update"), { desc = "Update file" })
keymap.set("n", "<leader>v", scmd("buffer#"), { desc = "Go to last buffer" })
-- Replaced by bufferline:
--keymap.set("n", "<leader>b", ":buffers<CR>:buffer<Space>", { desc = "Show All Buffers" })
keymap.set("n", "<leader>tz", scmd("term"), { desc = "Open Terminal" })
keymap.set("n", "<leader>mm", scmd("make"), { desc = "Make" })
keymap.set("n", "<leader>mc", scmd("cope"), { desc = "Quickfix List" })

-- "Q" prefix will usually denote quit stuff
keymap.set("n", "<leader>q", scmd("bd"), { desc = "NVim: Close Buffer" })
keymap.set("n", "<leader>Q", scmd("bd!"), { desc = "NVim: Close Buffer" })
keymap.set("n", "qb", scmd("%bd|e#|bd# "), { desc = "NVim: Close all other buffers" })

keymap.set({ "n", "i" }, "<C-P>", '<C-R><C-P>"', { desc = "Trying to copy into aligned" })

-- Switching rows
vim.api.nvim_set_keymap("n", "<A-K>", ":m .-2<CR>==", { noremap = true, silent = true })
-- Move line down
vim.api.nvim_set_keymap("n", "<A-J>", ":m .+1<CR>==", { noremap = true, silent = true })
-- Move selected lines up
vim.api.nvim_set_keymap("v", "<A-K>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
-- Move selected lines down
vim.api.nvim_set_keymap("v", "<A-J>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- To easily escape terminal mode
vim.api.nvim_set_keymap("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { noremap = true, silent = true })

-- Vimspector
--keymap.set("n", "<leader>dd", ":call vimspector#Launch()<CR>", { desc = "Launch VimSpector" })
--keymap.set("n", "<leader>ds", ":call vimspector#Reset()<CR>", {})
--keymap.set("n", "<leader>dc", ":call vimspector#Continue()<CR>", {})
--keymap.set("n", "<leader>de", "<Plug>VimspectorBalloonEval", {})
--keymap.set("n", "<leader>db", ":call vimspector#ToggleBreakpoint()<CR>", {})
--keymap.set("n", "<leader>dh", "<Plug>VimspectorStepOut", {})
--keymap.set("n", "<leader>dl", "<Plug>VimspectorStepInto", {})
--keymap.set("n", "<leader>dj", "<Plug>VimspectorStepOver", {})

-- Vimspector Replaced with vim-dap

--Lazy Clipboard Copyy
keymap.set("v", "<leader>y", '"+y', { silent = false })
keymap.set("n", "<leader>p", '"+p', { silent = false })
keymap.set("i", "<C-v>", '<C-R><C-P>"', { silent = false })
keymap.set("i", "<C-g>", "<C-R><C-P>+", { silent = false })

-- 2024-10-10: Adding Sorting
keymap.set("v","<leader>s", scmd("sort"), {silent = true})

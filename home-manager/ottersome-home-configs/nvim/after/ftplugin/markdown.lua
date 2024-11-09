function MarkdownFoldExpr(lnum)
	-- Get the current line
	local line = vim.fn.getline(lnum)
	-- Check if current line has bullet points if so skip
	if line:match("^%s*[%*%-%+]") then
		return "="
	end
	-- Match Markdown headers
	if line:match("^#") then
		-- Count the number of leading '#' characters to determine the header level
		return ">" .. #line:match("^#*")
	end
	-- Look upwards for the nearest preceding header
	for i = lnum - 1, 1, -1 do
		local prev_line = vim.fn.getline(i)
		if prev_line:match("^#") then
			-- Count the number of leading '#' characters to determine the header level
			return "=" .. #prev_line:match("^#*")
		end
	end
	-- Return '=' to indicate no folding for lines without a preceding header
	return "="
end

function write_time()
	local time = os.date("%H:%M")
	vim.api.nvim_put({ "- " .. time .. ": " }, "", true, true)
end
function makeSelectionBold()
	-- Get the start and end of the visual selection
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))
	-- Adjust the column numbers for block selections
	if vim.fn.visualmode() == "" then
		start_col = start_col - 1
		end_col = end_col + 1
	end
	-- Insert an underscore at the end of the selection
	vim.api.nvim_buf_set_text(0, end_line - 1, end_col - 1, end_line - 1, end_col - 1, { "**" })
	-- Insert an underscore at the start of the selection
	vim.api.nvim_buf_set_text(0, start_line - 1, start_col - 1, start_line - 1, start_col - 1, { "**" })
end
function makeSelectionItalic()
	-- Get the start and end of the visual selection
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))
	-- Adjust the column numbers for block selections
	if vim.fn.visualmode() == "" then
		start_col = start_col - 1
		end_col = end_col + 1
	end
	-- Insert an underscore at the end of the selection
	vim.api.nvim_buf_set_text(0, end_line - 1, end_col - 1, end_line - 1, end_col - 1, { "_" })
	-- Insert an underscore at the start of the selection
	vim.api.nvim_buf_set_text(0, start_line - 1, start_col - 1, start_line - 1, start_col - 1, { "_" })
end
function replace_stopping_points()
	vim.cmd([[ '<,'>s/\./\.\r/g ]])
	vim.cmd("noh")
end
local function paste_image_from_clipboard()
	-- FIX: Check if there is even an image in the clipboard
  -- I am removing it mosstly because of wayland. We can thing about how to work around it lataer
	-- local clipboard_type = vim.fn.system("xclip -selection clipboard  -o -t TARGETS")
	-- if not clipboard_type:find("image/png") then
	-- 	print("No image in clipboard")
	-- 	return
	-- end
  
	-- Get the current file's directory
	local current_file = vim.fn.expand("%:p:h")
	-- Return the path to the 'assets' folder rooted at the same path as the current file
	local img_folder = current_file .. "/assets"
	-- Ensure the image folder exists
	vim.fn.mkdir(img_folder, "p")
	-- Generate a unique filename for the image
	local img_name = os.date("%Y%m%d%H%M%S") .. ".png"
	local img_path = img_folder .. "/" .. img_name
	-- Get obidian Vault root
	local obsidian = require("obsidian")
	local vault_root = obsidian.get_client().dir.filename
	-- Ensure to handle spaces if exists in img_path so that command does not fail
	img_path = vim.fn.fnameescape(img_path)
	-- Use xclip or xsel to save the clipboard image to the file
	-- Check if it is mac or linux
	local pasted_path = require("obsidian.img_paste").paste_img({
		fname = img_name,
		default_dir = img_folder,
		default_name = img_name,
		should_confirm = true,
	})
	-- -- Check if there is even an image in the clipboard
	-- local clipboard_type = vim.fn.system("xclip -selection clipboard  -o -t TARGETS")
	-- if not clipboard_type:find("image/png") then
	-- 	print("No image in clipboard")
	-- 	return
	-- end
	-- local save_cmd = string.format("xclip -selection clipboard -t image/png -o > %s", img_path)
	-- os.execute(save_cmd)
	-- -- Insert the markdown image link at the current cursor position
	-- -- Conform to obsidan root path
	-- -- img_path = string.gsub(img_path, vault_root, "")
	-- If the image was pasted successfully, insert the markdown image link at the current cursor position

	if pasted_path ~= nil then
		local img_link = string.format("![%s](%s)", img_name, "./assets/" .. img_name)
		vim.api.nvim_put({ img_link }, "c", true, true)
	end
end
local function open_file()
	-- Will use XDG_OPEN to open files under cursor. Files will be in a typical markdown link format
	local file_path = vim.fn.expand("<cfile>")
	local cur_md_file_path = vim.fn.expand("%:p")
	local abs_path = vim.fn.fnamemodify(cur_md_file_path, ":h")
	local final_path = abs_path .. "/" .. file_path
	local open_cmd = string.format("xdg-open %s & disown", final_path)
	os.execute(open_cmd)
end

local nabla = require("nabla")
vim.keymap.set("n", "<leader>np", ':lua require("nabla").popup()<CR>', { desc = "Nabla: Open popup" })
vim.keymap.set("n", "<leader>no", nabla.enable_virt, { desc = "Nabla: Virt Enable" })
vim.keymap.set("n", "<leader>ni", nabla.disable_virt, { desc = "Nabla: Virt Diable" })

-- Create a conditional where the code below will only execute if under some child of the  `~/Document` directory
-- (for using obsidian)
local current_file_dir = vim.fn.expand("%:p:h")
local documents_dir = vim.fn.expand("~/Documents")

vim.opt.relativenumber = true
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.MarkdownFoldExpr(v:lnum)"
-- Activate only when editing Obsidian notes
if string.find(current_file_dir, documents_dir, 1, true) == 1 then
	-- Options
	-- vim.cmd([[colorscheme kanagawa-wave]])
	--- Obsidian Asks for this
	vim.opt.conceallevel = 1
	vim.opt.spelllang = { "en", "es" }
	vim.opt.spellsuggest = { "best", "9" }
	vim.opt.spell = true
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

	-- Rebindings
	vim.keymap.set("n", "<leader>of", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: QuickSwitch" })
	vim.keymap.set("n", "<leader>oD", ":ObsidianDailies<CR>", { desc = "Obsidian: Dailies" })
	vim.keymap.set("n", "<leader>od", ":ObsidianToday<CR>", { desc = "Obsidian: Open Today's Note" })
	vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>", { desc = "Obsidian: Open Backlinks" })
	vim.keymap.set("n", "<leader>ot", ":ObsidianTags<CR>", { desc = "Obsidian: Browse Tags" })
	vim.keymap.set("n", "<leader>it", ":ObsidianTemplate<CR>", { desc = "Obsidian: Insert Templates" })
	vim.keymap.set("n", "<leader>pa", paste_image_from_clipboard, { desc = "Mine: Paste img from clip" })
	vim.keymap.set("n", "<leader>oi", open_file, { desc = "Open image under cursor" })

	vim.keymap.set(
		"v",
		"<leader>rw",
		-- replace_stopping_points,
		":<C-u>lua replace_stopping_points()<CR>",
		{ desc = "Mine: Unwrap string", noremap = true, silent = true }
	)
	vim.keymap.set("i", "<M-t>", write_time, { desc = "Write time as a bullet point" })
	vim.keymap.set("v", "mi", ":<C-u>lua makeSelectionItalic()<CR>", { desc = "Make selection italic" })
	vim.keymap.set("v", "mb", ":<C-u>lua makeSelectionBold()<CR>", { desc = "Make selection bold" })

	-- Setup header folding
	-- vim.opt_local.foldexpr = "v:lua.MarkdownFoldExpr(v:lnum)"
end

local opt = vim.opt

-- Use Which Python to get python bin
local local_bin = vim.fn.exepath("python3")
-- set g:python3_host_prog to local_bin
-- vim.g.python3_host_prog = "/sbin/python"

-- Line Numbers
opt.relativenumber = true
opt.number = true

-- Fill Character
vim.opt.fillchars:append({ diff = "╱" })

-- Font
vim.opt.guifont = "Victor Mono:h14"
-- Spaces
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Cursorline
opt.cursorline = true

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Set persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"

-- Set Backups
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup"

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- opt.verbosefile = "/home/ottersome/temp/vim_verbose.log"
-- opt.verbose = 20

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.scrolloff = 12

-- turn off swapfile
--opt.swapfile = false

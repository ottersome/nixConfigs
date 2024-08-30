-- TODO: I have to ensure other stuff but I forgot
-- local has_luasnip, luasnip = pcall(require, "luasnip")
-- if not has_luasnip then
-- 	return
-- end

vim.maplocalleader = ","

-- local ls = require("luasnip")
-- local snippets = {
-- 	italic = ls.get_snippets("italic~")[1],
-- 	section = ls.get_snippets("section")[1],
-- }

--Check if italic is null, if so send notify
-- if snippets.italic == nil then
-- 	vim.notify("Italic snippet is null", vim.log.levels.ERROR)
-- end
--
-- -- Key mapping to expand a specific snippet by its trigger
-- vim.keymap.set("n", "<leader>it", function()
-- 	ls.snip_expand(snippets.italic)
-- end, { desc = "Tex: Italic" })
-- vim.keymap.set("n", "<leader>is", function()
-- 	ls.snip_expand(snippets.section)
-- end, { desc = "Tex: Section" })

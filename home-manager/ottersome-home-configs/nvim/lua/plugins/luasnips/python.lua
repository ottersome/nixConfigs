local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local d = luasnip.dynamic_node
local sn = luasnip.snippet_node

local function generate_subs(args)
	local nodes = {}
	local count = tonumber(args[1][1]) or 1 -- Get the number of sub-nodes from the first argument
	for j = 1, count do
		table.insert(nodes, t("- "))
		table.insert(nodes, i(j, "Var" .. j))
		if j < count then
			table.insert(nodes, t({ "", "" })) -- Add a separator between nodes
		end
	end
	return sn(nil, nodes)
end

return {
	s("exp", {
		t({ '"""', "" }),
		i(1, "Explanation"),
		t({ "", '"""' }),
	}),
	s("fexp", {
		t({ '"""', "" }),
		i(1, "Explanation"),
		t({ "", "", "" }),
		t("Variables "),
		t("("),
		i(2, "Num"),
		t(")"),
		t({ "", "---------", "" }),
		d(3, generate_subs, { 2 }),
		t({ "", "", "Returns " }),
		t("("),
		i(4, "Num"),
		t(")"),
		t({ "", "---------", "" }),
		d(5, generate_subs, { 4 }),
		t({ "", '"""', "" }),
	}),
}

local Job = require("plenary.job")
local function scmd(cmd)
  -- Limit cmd shown to 15 chars
  local handle = io.popen("which zsh")
  local zsh_path = handle:read("*a"):gsub("%s+", "") -- Remove any trailing newline
  handle:close()
  if zsh_path == "" then
    vim.notify("zsh not found in PATH", vim.log.levels.ERROR)
    return
  end
	Job:new({
    command = zsh_path,
    args = { '-c', cmd },
		on_exit = function(j, return_val)
			if return_val == 0 then
				-- Successful execution
				local result = table.concat(j:result(), "\n")
				vim.schedule(function()
					vim.notify("Command output:\n" .. result, vim.log.levels.INFO)
				end)
			else
				-- Error occurred
				local err = table.concat(j:stderr_result(), "\n")
				vim.schedule(function()
					vim.notify("Command failed with error:\n" .. err, vim.log.levels.ERROR)
				end)
			end
		end,
	}):start()
end
-- Export scmd functio as user command with `cmd` argument provided by user
vim.api.nvim_create_user_command("SCmd", function(opts)
	scmd(opts.args)
end, { nargs = 1 })

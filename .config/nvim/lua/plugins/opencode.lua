vim.g.opencode_opts = {
	server = {
		start = function()
			vim.fn.jobstart({ "kitty", "--title", "opencode", "opencode", "--port" }, {
				detach = true,
				cwd = vim.fn.getcwd(),
			})
		end,
		stop = function()
			vim.fn.system({ "pkill", "-f", "^opencode.*--port" })
		end,
	},
}

local opencode = require("opencode")

vim.keymap.set("n", "<leader>oa", function()
	opencode.ask("@buffer: ")
end)
vim.keymap.set("v", "<leader>oa", function()
	opencode.ask("@this: ")
end)

vim.keymap.set("n", "<leader>of", function()
	opencode.ask("@fix: ")
end)
vim.keymap.set("v", "<leader>of", function()
	opencode.ask("@this @fix: ")
end)

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	opts = { install_dir = vim.fn.stdpath("data") .. "/site" },
	config = function()
		local ts = require("nvim-treesitter")
		ts.install({ "lua", "go", "rust", "python", "markdown", "bash", "c", "java" }):wait(300000)
	end,
}

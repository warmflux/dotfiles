-- vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
vim.pack.add({
	-- colorschem
	"https://github.com/catppuccin/nvim",
	"https://github.com/folke/tokyonight.nvim",

	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua", -- search
	"https://www.github.com/nvim-tree/nvim-tree.lua", -- file explore
	"https://github.com/stevearc/oil.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

	-- Language Server Protocols
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp",

	"https://www.github.com/rafamadriz/friendly-snippets",
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/creativenull/efmls-configs-nvim",
	"https://github.com/L3MON4D3/LuaSnip",

	"https://github.com/OXY2DEV/markview.nvim",
	"https://github.com/mason-org/mason.nvim", -- market

	"https://github.com/linux-cultist/venv-selector.nvim", -- py select venv
	"https://github.com/jake-stewart/multicursor.nvim", -- multicursors

	-- ai
	"https://github.com/nickjvandyke/opencode.nvim", -- opencode
})

require("core.keymaps")
require("core.options")
require("core.autocmd")
require("core.terminal")
require("core.neovide")

require("lsp.lspconfig")

require("plugins.nvim-tree")
-- require("plugins.oil")
require("plugins.nvim-treesitter")
require("plugins.fzf")
require("plugins.mini")
require("plugins.gitsigns")
require("plugins.mason")
require("plugins.venv-selector")
require("plugins.multicursor")
require("plugins.opencode")
require("plugins.markview")

require("ui.colorscheme")
require("ui.statuline")

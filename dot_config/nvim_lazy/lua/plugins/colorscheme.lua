return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 999,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				telescope = { enabled = true },
				snacks = true,
			},
			custom_highlights = function(colors)
				return {
					LineNr = { fg = colors.text },
				}
			end,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}

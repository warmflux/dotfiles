---------------
-- 主题：catppuccin
---------------
vim.pack.add({
	{ src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

require('catppuccin').setup({
	flavour = 'mocha',
	transparent_background = true,
})

vim.cmd.colorscheme('catppuccin')

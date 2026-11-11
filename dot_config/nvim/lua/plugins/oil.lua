---------------
-- 文件管理：oil.nvim
---------------
vim.pack.add({
	'https://github.com/stevearc/oil.nvim',
})

require('oil').setup({})
vim.keymap.set("n","<leader>e","<Cmd>Oil<CR>",{ desc = "Open oil file manager" })

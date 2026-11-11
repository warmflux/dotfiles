---------------
-- 语法树：nvim-treesitter
---------------
vim.pack.add({
	'https://github.com/nvim-treesitter/nvim-treesitter',
})

local ts = require('nvim-treesitter')

-- 缺失的 parser 自动安装
local wanted = { 'lua', 'rust', 'go', 'c', 'python', 'bash' }
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(installed, lang)
end, wanted)
if #missing > 0 then
	ts.install(missing)
end

-- 为每个文件类型启动 treesitter 高亮
vim.api.nvim_create_autocmd('FileType', {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

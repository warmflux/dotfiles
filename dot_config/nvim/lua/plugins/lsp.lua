---------------
-- LSP：mason + lspconfig
---------------
vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/mason-org/mason.nvim',
})

require('mason').setup()

-- capabilities 取自 blink.cmp；init.lua 保证 plugins/cmp 先于本模块加载
local cmp = require('blink.cmp')

vim.lsp.config('*', {
	capabilities = cmp.get_lsp_capabilities(),
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
			diagnostics = { globals = { 'vim' } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			check = { command = 'clippy' },
			cargo = { allFeatures = true },
			procMacro = { enable = true },
		},
	},
})

vim.lsp.enable({ 'clangd', 'gopls', 'lua_ls', 'rust_analyzer', 'bashls' })

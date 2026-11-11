---------------
-- 补全：blink.cmp
---------------
vim.pack.add({
	'https://github.com/saghen/blink.lib',
	'https://github.com/saghen/blink.cmp',
})

local cmp = require('blink.cmp')
cmp.build():pwait()
-- 只能调用一次：setup() 内部有 has_setup 守卫，第二次会被静默忽略
cmp.setup({
	keymap = {
		preset = 'default',
	},
	appearance = { nerd_font_variant = 'mono' },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 400 },
		menu = { max_height = 10 },
	},
	sources = { default = { 'lsp', 'path', 'buffer','snippets',} },
	signature = { enabled = true },
	fuzzy = { implementation = 'rust' },
})

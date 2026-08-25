require("core.keymaps")
require("core.options")
require("core.autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.snacks"),
	require("plugins.treesitter"),
	require("plugins.colorscheme"),
	require("plugins.whichkey"),
	require("plugins.lualine"),
	require("plugins.mini"),
	require("plugins.gitsigns"),

	require("lsp.blink"),
	require("lsp.lspconfig"),
	require("lsp.conform"),
  require("lsp.mason"),
})

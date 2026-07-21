local ok, venv_selector = pcall(require, "venv-selector")
if not ok then
	return
end

venv_selector.setup({
	options = {},
	search = {},
})

vim.keymap.set("n", "<leader>cv", "<cmd>VenvSelect<cr>", {
	noremap = true,
	silent = true,
	desc = "Select Python Virtual Env",
})

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("Colorscheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "Cursor", { bg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "Cursor2", { bg = "#89b4fa" })
		if package.loaded["snacks"] then
			vim.api.nvim_set_hl(0, "SnacksPicker", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksPickerBorder", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = "NONE" })
		end
	end,
})

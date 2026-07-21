local ok, mc = pcall(require, "multicursor-nvim")
if not ok then
	return
end

mc.setup()
local set = vim.keymap.set

-- 切换光标
set({ "n", "v" }, "<leader>m", mc.toggleCursor, { noremap = true, silent = true })

-- 视觉模式匹配
set("v", "<leader>m", mc.matchCursors, { noremap = true, silent = true })

-- ESC 清空多光标（你最核心的功能）
set("n", "<esc>", function()
	if not mc.cursorsEnabled() then
		mc.enableCursors()
	elseif mc.hasCursors() then
		mc.clearCursors()
	else
		vim.cmd("normal! <esc>")
	end
end, { noremap = true, silent = true })

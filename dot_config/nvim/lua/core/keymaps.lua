---------------
-- 按键映射
---------------
-- 注意：这里定义 <leader>，所有使用 <leader> 的模块都必须在本文件之后加载。

-- leader -------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 插入模式 -----------------------------------------------------------------
vim.keymap.set("i","jk","<ESC>",{silent=true,desc="exit insert mode"})

-- 窗口导航与调整 -----------------------------------------------------------
vim.keymap.set("n","<C-h>","<C-w>h")
vim.keymap.set("n","<C-j>","<C-w>j")
vim.keymap.set("n","<C-k>","<C-w>k")
vim.keymap.set("n","<C-l>","<C-w>l")
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- 光标移动 ---------------------------------------------------------------
vim.keymap.set({"n","v"},"H","^")
vim.keymap.set({"n","v"},"L","$")
vim.keymap.set("n","n","nzzzv")
vim.keymap.set("n","N","Nzzzv")

-- 行与选区编辑 -------------------------------------------------------------
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set({"n","v"},"-",[["_]],{noremap = true,desc = "Black register prefix"})

-- 诊断 ---------------------------------------------------------------------
vim.keymap.set("n","<leader>q",function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end)
vim.keymap.set('n','<leader>ld',vim.diagnostic.open_float)

-- LSP 跳转 -----------------------------------------------------------------
vim.keymap.set("n", "gd", function()
  if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" }) == 0 then
    return vim.cmd.normal({ args = { "gd" }, bang = true })
  end
  vim.lsp.buf.definition()
end, { desc = "go to definition" })
-- gD：分屏打开定义
vim.keymap.set("n", "gD", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "definition in split" })

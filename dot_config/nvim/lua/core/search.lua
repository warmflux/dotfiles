---------------
-- 搜索
---------------
-- 使用 ripgrep 作为 :grep 的后端；<leader>g 交互式搜索
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.keymap.set("n","<leader>g",function()
    vim.ui.input({ prompt = "Grep: " },function(pattern)
        if pattern then
            vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
            vim.cmd("copen")
        end
    end)
end,{ silent = true })

-- ===========================================================================
-- Neovim 配置入口 (init.lua)
-- ===========================================================================
--
-- 目录结构：
--   init.lua              入口：按依赖顺序加载各分类
--   lua/core/             核心设置，不依赖任何插件
--     options.lua         编辑器选项
--     keymaps.lua         按键映射（同时定义 <leader>）
--     autocmds.lua        自动命令
--     search.lua          搜索（grepprg / <leader>g）
--   lua/plugins/          插件，各自通过 vim.pack.add 安装并配置
--     cmp.lua             代码补全（blink.cmp）
--     lsp.lua             LSP 客户端（mason + lspconfig）
--     treesitter.lua      语法高亮与折叠（nvim-treesitter）
--     theme.lua           配色主题（catppuccin）
--     oil.lua             文件管理器（oil.nvim）
--     smear-cursor        光标丝滑插件
--
-- 加载顺序约定：
--   1. core 全部先加载。keymaps 定义 <leader>，凡是用到 <leader> 的文件
--      （如 plugins/oil、core/search）都必须排在它之后
--   2. cmp 必须早于 lsp —— lsp 的 capabilities 取自 blink.cmp
--   3. theme 放在插件之后，让配色最后覆盖各插件的默认高亮
-- ===========================================================================

-- 依赖检查：本配置用 vim.pack 管理插件，需要 Neovim 0.12+
if vim.fn.has("nvim-0.12") == 0 then
	vim.notify("本配置依赖 vim.pack，请升级到 Neovim >= 0.12", vim.log.levels.ERROR)
	return
end

-- 一、核心设置 ---------------------------------------------------------------
require("core.options")
require("core.keymaps") -- keymaps 定义 <leader>，必须在任何使用 <leader> 的模块之前
require("core.autocmds")
require("core.search")

-- 二、插件 -------------------------------------------------------------------
require("plugins.cmp") -- cmp 先于 lsp：lsp 需要 blink.cmp 提供的 capabilities
require("plugins.lsp")
require("plugins.treesitter")
require("plugins.theme")
require("plugins.oil")
require("plugins.cursor_animation")

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},

	config = function()
		-- 1. 前置补丁：LSP悬浮窗口圆角边框
		do
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig(contents, syntax, opts, ...)
			end
		end

		-- LSP 附加快捷键回调
		local function lsp_on_attach(client, bufnr)
			-- K 悬浮文档
			vim.keymap.set(
				"n",
				"K",
				vim.lsp.buf.hover,
				{ buffer = bufnr, noremap = true, silent = true, desc = "LSP Hover Doc" }
			)
			vim.keymap.set("n", "<leader>ld", function()
				vim.diagnostic.open_float({ scope = "line" })
			end, { noremap = true, silent = true, buffer = bufnr, desc = "Open Line diagnostics" })
			vim.keymap.set(
				"n",
				"<leader>ca",
				vim.lsp.buf.code_action,
				{ noremap = true, silent = true, buffer = bufnr, desc = "Code Action" }
			)
			vim.keymap.set(
				"n",
				"<leader>rn",
				vim.lsp.buf.rename,
				{ noremap = true, silent = true, buffer = bufnr, desc = "Rename Name" }
			)

			local support_organize = client:supports_method("textDocument/codeAction", bufnr, {
				context = { only = { "source.organizeImports" } },
			})
			if support_organize then
				vim.keymap.set("n", "<leader>oi", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.organizeImports" }, diagnostics = {} },
						apply = true,
						bufnr = bufnr,
					})
				end, { noremap = true, silent = true, buffer = bufnr, desc = "Organize Imports" })
			end
		end

		vim.lsp.config["*"] = {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			on_attach = lsp_on_attach,
		}

		-- Lua LSP
		vim.lsp.config("lua_ls", {
			cmd = { vim.fn.exepath("lua-language-server") },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- Go gopls
		vim.lsp.config("gopls", {
			cmd = { vim.fn.exepath("gopls") },
		})
		vim.lsp.enable("gopls")

		-- Rust analyzer
		vim.lsp.config("rust_analyzer", {
			cmd = { vim.fn.exepath("rust-analyzer") },
			settings = {
				["rust-analyzer"] = {
					cargo = { buildScripts = { enable = true } },
					procMacro = { enable = true },
					completion = { autoImport = { enable = true } },
				},
			},
		})
		vim.lsp.enable("rust_analyzer")

		vim.lsp.config("jdtls", {
			cmd = { vim.fn.exepath("jdtls") },
			settings = {
				java = { format = { enabled = true } },
			},
		})
		vim.lsp.enable("jdtls")
	end,
}

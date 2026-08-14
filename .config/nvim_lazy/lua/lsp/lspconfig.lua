return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},

	config = function()
		do
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig(contents, syntax, opts, ...)
			end
		end

		local function lsp_on_attach(client, bufnr)
			vim.keymap.set(
				"n",
				"K",
				vim.lsp.buf.hover,
				{ buffer = bufnr, noremap = true, silent = true, desc = "LSP Hover Doc" }
			)

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
					lens = {
						debug = { enable = true },
						enable = true,
						implementations = { enable = true },
						references = {
							adt = { enable = true },
							enumVariant = { enable = true },
							method = { enable = true },
							trait = { enable = true },
						},
						run = { enable = true },
						updateTest = { enable = true },
					},
					checkOnSave = {
						command = "clippy",
						enable = true,
					},
					rename = {
						enable = true,
						crossFile = true,
					},
					codeAction = {
						enable = true,
						importGranularity = "crate",
						importPrefix = "by_self",
					},
				},
			},
		})
		vim.lsp.enable("rust_analyzer")

		-- java jdtls
		vim.lsp.config("jdtls", {
			cmd = { vim.fn.exepath("jdtls") },
			settings = {
				java = { format = { enabled = true } },
			},
		})
		vim.lsp.enable("jdtls")

		-- c/cpp clangd
		vim.lsp.config("clangd", {
			cmd = { vim.fn.exepath("clangd") },
			settings = {
				format = {
					enable = true,
					style = "file",
				},
				completion = {
					placeholder = true,
					deduction = true,
				},
				diagnostics = {
					unusedIncludes = true,
					missingPrototypes = true,
				},
				index = {
					standardLibrary = true,
				},
			},
		})
		vim.lsp.enable("clangd")
	end,
}

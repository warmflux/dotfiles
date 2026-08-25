return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
    "mason-org/mason.nvim",
	},
	config = function()
		local diagnostic_signs = {
			Error = "E",
			Warn = "W",
			Hint = "H",
			Info = "I",
		}

		vim.diagnostic.config({
			-- virtual_text = { prefix = "●", spacing = 4 },
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
					[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
					[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
					[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
				focusable = false,
				style = "minimal",
			},
		})

		do
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig(contents, syntax, opts, ...)
			end
		end

		local function lsp_on_attach(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end

			local bufnr = ev.buf
			-- local opts = { noremap = true, silent = true, buffer = bufnr }

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
				{ noremap = true, silent = true, buffer = bufnr, desc = "Rename" }
			)

			if client:supports_method("textDocument/codeAction", bufnr) then
				vim.keymap.set("n", "<leader>oi", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.organizeImports" }, diagnostics = {} },
						apply = true,
						bufnr = bufnr,
					})
					vim.defer_fn(function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end, 50)
				end, { noremap = true, silent = true, buffer = bufnr, desc = "Organise Imports" })
			end
		end

		vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

		vim.lsp.config["*"] = {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		}

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					telemetry = { enable = false },
				},
			},
		})
		vim.lsp.config("pyright", {})
		-- vim.lsp.config("bashls", {})
		vim.lsp.config("ts_ls", {})

		vim.lsp.config("gopls", {})

		vim.lsp.config("clangd", {})

		vim.lsp.config("jdtls", {})

		vim.lsp.config("rust_analyzer", {
			-- on_attach = function(client, bufnr)
			-- 	-- Enable inlay hints for type inference
			-- 	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			-- end,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						buildScripts = { enable = true },
					},
					procMacro = {
						enable = true,
					},
					completion = {
						autoImport = { enable = true },
					},
				},
			},
		})

		vim.lsp.enable({
			"lua_ls",
			"jdtls",
			"clangd",
			"rust_analyzer",
			"gopls",
      "pyright",
		})
	end,
}

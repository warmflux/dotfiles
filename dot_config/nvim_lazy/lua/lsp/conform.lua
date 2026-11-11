return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofumpt" },
			rust = { "rustfmt" },
			java = { lsp_format = "prefer" },
			c = { lsp_format = "prefer" },
			cpp = { lsp_format = "prefer" },
			-- python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			-- markdown = { "prettier", "injected" },
			bash = { "shfmt" },
			sh = { "shfmt" },
      python = {"ruff"},
			["*"] = { "trim_whitespace" }, -- 全局删除行尾空格
		},

		format_on_save = {
			timeout_ms = 500,
		},
		notify_on_error = true,
	},
}

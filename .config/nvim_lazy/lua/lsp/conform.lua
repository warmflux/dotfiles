return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofmt" },
			rust = { "rustfmt" },
			java = { lsp_format = "prefer" },
			c = { lsp_format = "prefer" },
			cpp = { lsp_format = "prefer" },
			-- python = { "ruff_organize_imports", "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier", "injected" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			["*"] = { "trim_whitespace" }, -- 全局删除行尾空格
		},

		format_on_save = {
			timeout_ms = 500,
			-- lsp_format = "never", -- 完全禁用LSP格式化，避免冲突
		},

		formatters = {
			stylua = { command = os.getenv("HOME") .. "/.local/share/mise/installs/stylua/latest/stylua" },
			gofmt = { command = os.getenv("HOME") .. "/.local/share/mise/installs/go/1.26.5/bin/gofmt" },
			rustfmt = { command = os.getenv("HOME") .. "/.cargo/bin/rustfmt" },
			prettier = { command = os.getenv("HOME") .. "/.local/share/mise/installs/prettier/latest/bin/prettier" },
		},

		notify_on_error = true,
	},
}

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = false,
	},
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = true,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			local m = name:match("^%.")
			return m ~= nil
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names with numbers in a more intuitive order for humans.
		-- Can be "fast", true, or false. "fast" will turn it off for large directories.
		natural_order = "fast",
		-- Sort file and directory names case insensitive
		case_insensitive = false,
		sort = {
			-- sort order can be "asc" or "desc"
			-- see :help oil-columns to see which columns are sortable
			{ "type", "asc" },
			{ "name", "asc" },
		},
		-- Customize the highlight group for the file name
		highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
			return nil
		end,
	},
	-- Configuration for the file preview window
	preview_win = {
		-- Whether the preview window is automatically updated when the cursor is moved
		update_on_cursor_moved = true,
		-- How to open the preview window "load"|"scratch"|"fast_scratch"
		preview_method = "fast_scratch",
		-- A function that returns true to disable preview on a file e.g. to avoid lag
		disable_preview = function(filename)
			return false
		end,
		-- Window-local options to use for preview window buffers
		win_options = {},
	},
	keymaps = {
		["<CR>"] = "actions.select",
		["<C-p>"] = "actions.preview",
		["<C-l"] = "actions.refresh",
		["q"] = { "actions.close", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
	},
	use_default_keymaps = true,
	delete_to_trash = false,
	skip_confirm_for_simple_edits = true,
	constrain_cursor = "name",
	watch_for_changes = true,
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

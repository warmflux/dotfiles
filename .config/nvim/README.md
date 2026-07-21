<p align="center">
  <img src="https://img.shields.io/badge/Neovim-0.10+-green.svg?style=flat-square&logo=neovim">
  <img src="https://img.shields.io/badge/Rust-required-orange?style=flat-square&logo=rust">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square">
</p>

# nvim

Modern Neovim configuration using the built-in `vim.pack.add` package manager, Catppuccin Mocha colorscheme, and full LSP / formatting support.

## Features

- **Blazing-fast completion** via [blink.cmp](https://github.com/Saghen/blink.cmp) — Rust-powered fuzzy matching
- **7 LSP servers** with automatic setup: `lua_ls`, `pyright`, `bashls`, `ts_ls`, `gopls`, `clangd`, `jdtls`
- **Format on save** via efm — lua, python, go, js/ts/jsx/tsx, json, css/scss, html, sh, c/cpp
- **Fuzzy finding** with [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- **File explorer** via [oil.nvim](https://github.com/stevearc/oil.nvim) (edit directory as a buffer)
- **Git integration** with [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- **Editor enhancements** from [mini.nvim](https://github.com/echasnovski/mini.nvim) (ai, comment, surround, move, pairs, etc.)
- **Tree-sitter** syntax highlighting
- **Multi-cursor** support
- **OpenCode AI** integration
- **Markdown preview** with [markview.nvim](https://github.com/OXY2DEV/markview.nvim)

## Requirements

| Dependency | Notes |
|------------|-------|
| Neovim >= 0.10 | Uses `vim.pack.add` and `vim.lsp.config` |
| Nerd Font | Required for statusline icons |
| **Rust toolchain (cargo)** | **Required by [blink.cmp](https://github.com/Saghen/blink.cmp).** Compilation happens automatically on first load. Install via: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| [Mason](https://github.com/mason-org/mason.nvim) | Installs LSP / formatter / linter binaries |

## Installation

```bash
git clone https://github.com/warmflux/nvim-for-marjaro ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

> **Note:** The first launch will compile `blink.cmp` from source via `cargo build` — this may take a minute.

## Structure

```
~/.config/nvim
├── init.lua              # Entry point, plugin declarations (vim.pack.add)
├── lua/
│   ├── core/             # Options, keymaps, autocmds, terminal, neovide
│   │   ├── keymaps.lua
│   │   ├── options.lua
│   │   ├── autocmd.lua
│   │   ├── terminal.lua
│   │   └── neovide.lua
│   ├── lsp/              # LSP configuration
│   │   ├── lspconfig.lua # blink.cmp setup, LSP servers, efm
│   │   └── jdtls.lua     # Java LSP (jdtls)
│   ├── plugins/          # Plugin-specific configs
│   │   ├── oil.lua, nvim-treesitter.lua, fzf.lua, mini.lua
│   │   ├── gitsigns.lua, mason.lua, venv-selector.lua
│   │   ├── multicursor.lua, opencode.lua, markview.lua
│   │   └── ...
│   └── ui/               # Appearance
│       ├── colorscheme.lua
│       └── statuline.lua
├── init.lua
├── nvim-pack-lock.json
├── LICENSE
└── README.md
```

## Plugins

| Category | Plugin |
|----------|--------|
| Colorscheme | [catppuccin/nvim](https://github.com/catppuccin/nvim), [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) |
| File explorer | [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim) |
| Fuzzy finder | [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua) |
| Statusline | Custom (focus-aware, Nerd Font icons) |
| Terminal | Floating toggle (`<C-\>`) |
| Git | [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) |
| Editor suite | [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim) |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| Completion | [blink.cmp](https://github.com/Saghen/blink.cmp) (Rust — requires `cargo build`) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) |
| LSP | 7 servers (`lua_ls`, `pyright`, `bashls`, `ts_ls`, `gopls`, `clangd`, `jdtls`) + efm |
| Formatter / Linter | [efmls-configs-nvim](https://github.com/creativenull/efmls-configs-nvim) via Mason |
| AI | [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) |
| Notes | [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) (optional) |
| Python venv | [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) (optional) |
| Markdown | [markview.nvim](https://github.com/OXY2DEV/markview.nvim) |
| Multi-cursor | [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) |

## Keymaps

Leader key is `<Space>`.

### Navigation & Motion

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `j` / `k` | `n` | Wrap-aware line movement (`gj`/`gk`) |
| `H` / `L` | `n,v` | Move to start/end of line (`^` / `$`) |
| `n` / `N` | `n` | Next/prev search result (centered) |
| `<C-d>` / `<C-u>` | `n` | Half page down/up (centered) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | `n` | Navigate windows |
| `<C-Up>` / `<C-Down>` | `n` | Resize window height ±2 |
| `<C-Left>` / `<C-Right>` | `n` | Resize window width ±2 |

### Buffer & Window Management

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>bn` | `n` | Next buffer |
| `<leader>bp` | `n` | Previous buffer |
| `<leader>sv` | `n` | Vertical split |
| `<leader>sh` | `n` | Horizontal split |

### File Explorer

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>e` | `n` | Open parent directory (oil.nvim) |

### Fuzzy Finding (fzf-lua)

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>ff` | `n` | Find files |
| `<leader>fg` | `n` | Live grep |
| `<leader>fb` | `n` | Switch buffer |
| `<leader>fh` | `n` | Help tags |
| `<leader>fx` | `n` | Document diagnostics |
| `<leader>fX` | `n` | Workspace diagnostics |
| `<leader>fd` | `n` | LSP definitions |
| `<leader>fr` | `n` | LSP references |
| `<leader>ft` | `n` | LSP type definitions |
| `<leader>fs` | `n` | Document symbols |
| `<leader>fw` | `n` | Workspace symbols |
| `<leader>fi` | `n` | LSP implementations |

### LSP

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `K` | `n` | Hover documentation |
| `gd` | `n` | Go to definition |
| `gD` | `n` | Go to definition (vsplit) |
| `<leader>ca` | `n` | Code action |
| `<leader>rn` | `n` | Rename symbol |
| `<leader>D` | `n` | Line diagnostics |
| `<leader>d` | `n` | Cursor diagnostics |
| `<leader>nd` | `n` | Next diagnostic |
| `<leader>pd` | `n` | Previous diagnostic |
| `<leader>oi` | `n` | Organize imports & format |
| `<leader>q` | `n` | Open diagnostic list (loclist) |
| `<leader>dl` | `n` | Show line diagnostics float |

### Completion (blink.cmp)

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<C-Space>` | `i` | Trigger completion |
| `<C-j>` / `<C-k>` | `i` | Select next/prev item |
| `<CR>` | `i,c` | Confirm selection |
| `<Tab>` / `<S-Tab>` | `i,s,c` | Smart navigation / fallback |

### Git (gitsigns)

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `]h` / `[h` | `n` | Next/prev git hunk |
| `<leader>hs` | `n` | Stage hunk |
| `<leader>hr` | `n` | Reset hunk |
| `<leader>hp` | `n` | Preview hunk |
| `<leader>hb` | `n` | Blame line |
| `<leader>hB` | `n` | Toggle inline blame |
| `<leader>hd` | `n` | Diff this |

### Editing

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `jk` / `kj` | `i` | Exit insert mode |
| `<leader>p` | `x` | Paste without yanking |
| `x` | `n,v` | Delete char (no register) |
| `xx` | `n` | Delete line (no register) |
| `<A-j>` / `<A-k>` | `n` | Move line down/up |
| `<A-j>` / `<A-k>` | `v` | Move selection down/up |
| `<` / `>` | `v` | Indent and reselect |
| `J` | `n` | Join lines (preserve cursor) |
| `<leader>pa` | `n` | Copy full file path |
| `<leader>c` | `n` | Clear search highlights |
| `<leader>td` | `n` | Toggle diagnostics |

### Multiple Cursors

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>m` | `n,v` | Toggle / match cursors |
| `<Esc>` | `n` | Clear multi-cursors |

### Terminal

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `t` | `n` | Open floating terminal |
| `<leader>t` | `t` | Close floating terminal |

### OpenCode AI

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>oa` | `n` | Ask about current buffer |
| `<leader>oa` | `v` | Ask about visual selection |
| `<leader>of` | `n` | Fix |
| `<leader>of` | `v` | Fix selection |

### Obsidian Notes

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>nn` | `n` | New note |
| `<leader>nf` | `n` | Find note |
| `<leader>ns` | `n` | Search notes |
| `<leader>nt` | `n` | Today's daily note |
| `<leader>nw` | `n` | Switch workspace |

### Python

| Keys | Mode | Action |
| ---- | ---- | ------ |
| `<leader>cv` | `n` | Select Python virtual env |

## Format on save

Enabled for: `lua`, `python`, `go`, `js/ts/jsx/tsx`, `json`, `css/scss`, `html`, `sh`, `c/cpp` via efm.

## License

[MIT](LICENSE) © warmflux

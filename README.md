# Neovim Config

Neovim 0.12 with vim.pak. Leader key is `<space>`.

## Plugins

- nvim-lspconfig (LSP server configs)
- blink.cmp (completion)
- nvim-treesitter (parser management)
- fzf-lua (fuzzy finder)
- tokyonight.nvim (colorscheme)
- mini.pairs (autopairs)

## Keymaps

### General

| Key | Action |
|-----|--------|
| `Cmd+s` | Save |
| `Cmd+/` | Toggle comment |
| `Alt+j` / `Alt+Down` | Move line/selection down |
| `Alt+k` / `Alt+Up` | Move line/selection up |

### Fuzzy Finder

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fs` | LSP document symbols |
| `<leader>fw` | LSP workspace symbols |
| `<leader>fd` | Document diagnostics |
| `<leader>fr` | Resume last search |

### LSP (custom)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `<leader>D` | Type definition |

### LSP (built-in)

| Key | Action |
|-----|--------|
| `K` | Hover |
| `grn` | Rename |
| `gra` | Code action |
| `grr` | References |
| `gri` | Implementations |
| `gO` | Document symbols |

### General (built-in)

| Key | Action |
|-----|--------|
| `gcc` / `gc` | Toggle comment (line / selection) |
| `[d` / `]d` | Prev / next diagnostic |
| `Ctrl-w s` | Horizontal split |
| `Ctrl-w v` | Vertical split |
| `Ctrl-w h/j/k/l` | Navigate panes |
| `Ctrl-w q` | Close pane |

-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
local o = vim.opt
o.number = true
o.relativenumber = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.updatetime = 250
o.undofile = true
o.clipboard = 'unnamedplus'
o.splitright = true
o.splitbelow = true
o.scrolloff = 8
o.cursorline = true

--------------------------------------------------------------------------------
-- Plugins (vim.pak)
--------------------------------------------------------------------------------
local gh = function(r) return 'https://github.com/' .. r end

-- Build blink.cmp after install/update (requires cargo)
vim.api.nvim_create_autocmd('User', {
  pattern = 'PackChanged',
  callback = function()
    local dir = vim.fn.stdpath('data') .. '/site/pack/core/opt/blink.cmp'
    if vim.fn.isdirectory(dir) == 1 then
      vim.notify('Building blink.cmp...')
      vim.fn.system({ 'cargo', 'build', '--release', '--manifest-path', dir .. '/Cargo.toml' })
      if vim.v.shell_error == 0 then
        vim.notify('blink.cmp built. Restart nvim to load.')
      else
        vim.notify('blink.cmp build failed. Ensure cargo is installed.', vim.log.levels.ERROR)
      end
    end
  end,
})

vim.pack.add({
  gh('neovim/nvim-lspconfig'),
  { src = gh('saghen/blink.cmp'), version = 'v1.10.1' },
  gh('nvim-treesitter/nvim-treesitter'),
  gh('ibhagwan/fzf-lua'),
  gh('folke/tokyonight.nvim'),
  gh('echasnovski/mini.pairs'),
})

--------------------------------------------------------------------------------
-- Colorscheme
--------------------------------------------------------------------------------
vim.cmd.colorscheme('tokyonight')

--------------------------------------------------------------------------------
-- Treesitter (highlighting/indent are built-in; plugin just manages parsers)
--------------------------------------------------------------------------------
local ts_parsers = {
  'typescript', 'tsx', 'javascript', 'json', 'html', 'css',
  'go', 'gomod',
  'rust', 'toml',
  'python',
  'r',
  'yaml', 'bash', 'dockerfile',
  'markdown', 'markdown_inline',
}

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local installed = require('nvim-treesitter.config').get_installed('parsers')
    local missing = vim.tbl_filter(function(p)
      return not vim.list_contains(installed, p)
    end, ts_parsers)
    if #missing > 0 then
      require('nvim-treesitter').install(missing)
    end
  end,
})

--------------------------------------------------------------------------------
-- Completion (blink.cmp)
--------------------------------------------------------------------------------
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
  blink.setup({
    keymap = { preset = 'default' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    completion = {
      documentation = { auto_show = true },
    },
    fuzzy = { implementation = 'prefer_rust' },
  })
end

--------------------------------------------------------------------------------
-- Autopairs
--------------------------------------------------------------------------------
require('mini.pairs').setup()

--------------------------------------------------------------------------------
-- Fuzzy finder
--------------------------------------------------------------------------------
require('fzf-lua').setup({ 'fzf-native' })

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
if blink_ok then
  vim.lsp.config('*', {
    capabilities = blink.get_lsp_capabilities(),
  })
end
vim.lsp.enable({ 'ts_ls', 'gopls', 'rust_analyzer', 'pyright', 'r_language_server' })

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local map = vim.keymap.set

-- Fuzzy finder
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })
map('n', '<leader>fh', '<cmd>FzfLua helptags<cr>', { desc = 'Help' })
map('n', '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'Symbols' })
map('n', '<leader>fw', '<cmd>FzfLua lsp_workspace_symbols<cr>', { desc = 'Workspace symbols' })
map('n', '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Diagnostics' })
map('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume' })

-- LSP (supplements built-in grn/gra/grr/gri/gO/K)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local b = { buffer = ev.buf }
    map('n', 'gd', vim.lsp.buf.definition, b)
    map('n', 'gD', vim.lsp.buf.declaration, b)
    map('n', '<leader>D', vim.lsp.buf.type_definition, b)
  end,
})

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})

-- ┌──────────────────────────────────────────────────────────────────────┐
-- │ Config Neovim — 0.12+                                                │
-- │ Gestionnaire de plugins : vim.pack (natif)                           │
-- │ LSP : vim.lsp.config / vim.lsp.enable (natif) + nvim-lspconfig       │
-- │ Langages : TypeScript, PHP, Go, Zig, Rust (+ Lua pour la config)     │
-- └──────────────────────────────────────────────────────────────────────┘

if vim.fn.has 'nvim-0.12' == 0 then
  vim.notify('Cette config nécessite Neovim >= 0.12', vim.log.levels.ERROR)
  return
end

-- Le leader doit être défini avant tout mapping.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Cache du bytecode Lua (démarrage plus rapide).
vim.loader.enable()

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- Hooks de build (doivent être déclarés AVANT le premier vim.pack.add).
require 'config.pack'

-- Plugins, dans l'ordre de dépendance.
require 'plugins.ui'
require 'plugins.editor'
require 'plugins.treesitter'
require 'plugins.lsp'
require 'plugins.completion'
require 'plugins.format'
require 'plugins.test'
require 'plugins.debug'
require 'plugins.ai'

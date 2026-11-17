-- blink.cmp : complétion rapide (fuzzy matcher en Rust, binaire pré-compilé
-- téléchargé automatiquement grâce au tag de version).
vim.pack.add {
  gh 'rafamadriz/friendly-snippets',
  gh('saghen/blink.cmp', { version = vim.version.range '1.*' }),
}

require('blink.cmp').setup {
  -- 'default' : <C-y> accepte, <C-n>/<C-p> naviguent, <C-space> ouvre,
  -- <C-e> ferme, <C-k> signature, <Tab>/<S-Tab> sautent dans les snippets.
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    ghost_text = { enabled = false }, -- laissé à Copilot
    menu = { draw = { treesitter = { 'lsp' } } },
  },
  signature = { enabled = true },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
    providers = {
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
  cmdline = { completion = { menu = { auto_show = true } } },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

-- Capabilities blink pour tous les serveurs LSP
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

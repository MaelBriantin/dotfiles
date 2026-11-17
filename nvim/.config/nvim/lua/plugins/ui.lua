vim.pack.add {
  gh('projekt0n/github-nvim-theme', { version = vim.version.range '1.*' }),
  gh 'f-person/auto-dark-mode.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'folke/which-key.nvim',
}

-- ── Thème : calqué sur Rex ───────────────────────────────────────────────
-- Rex « merino-dark »  = palette GitHub Dark Default  → github_dark_default
-- Rex « merino-light » = palette GitHub Light Default → github_light_default
-- Bascule auto selon le thème macOS (comme Rex).
require('github-theme').setup {
  options = { styles = { comments = 'italic' } },
}

local rex = {
  dark = { scheme = 'github_dark_default', bg = '#0d1117', fg = '#e6edf3', cursor = '#2f81f7' },
  light = { scheme = 'github_light_default', bg = '#ffffff', fg = '#1f2328', cursor = '#0969da' },
}

local function apply(mode)
  local t = rex[mode]
  -- Repartir de zéro : sinon changer 'background' recharge l'ancien thème
  -- et laisse traîner ses couleurs.
  vim.cmd 'highlight clear'
  vim.g.colors_name = nil
  vim.o.background = mode
  vim.cmd.colorscheme(t.scheme)
  -- Fond / texte / curseur exactement identiques au terminal Rex.
  -- En mode transparent, pas de fond : on voit celui du terminal (glass Rex).
  local bg = vim.g.transparent and 'NONE' or t.bg
  local hl = vim.api.nvim_set_hl
  hl(0, 'Normal', { fg = t.fg, bg = bg })
  hl(0, 'NormalNC', { fg = t.fg, bg = bg })
  hl(0, 'SignColumn', { bg = bg })
  hl(0, 'FoldColumn', { bg = bg })
  hl(0, 'EndOfBuffer', { fg = t.bg, bg = bg })
  hl(0, 'Cursor', { fg = t.bg, bg = t.cursor })
  -- Flottants (hover, which-key, notifs, complétion…) : sans fond aussi, ils
  -- prennent le flou « glass » de Rex ; la bordure arrondie les délimite.
  -- (Les groupes des plugins pointent tous vers NormalFloat ou Pmenu.)
  if vim.g.transparent then
    for _, g in ipairs { 'NormalFloat', 'Pmenu' } do
      local h = vim.api.nvim_get_hl(0, { name = g, link = false })
      h.bg = nil
      hl(0, g, h)
    end
  end
end

-- Fond transparent par défaut ; <leader>ut pour basculer.
vim.g.transparent = true

local function current_mode() return vim.o.background == 'light' and 'light' or 'dark' end
apply(current_mode())

require('auto-dark-mode').setup {
  set_dark_mode = function() apply 'dark' end,
  set_light_mode = function() apply 'light' end,
}

vim.keymap.set('n', '<leader>ut', function()
  vim.g.transparent = not vim.g.transparent
  apply(current_mode())
end, { desc = 'Toggle fond transparent' })

-- ── mini.nvim (modules UI) ───────────────────────────────────────────────
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons() -- compat pour les plugins qui attendent devicons

require('mini.notify').setup { lsp_progress = { enable = true, duration_last = 1500 } }
vim.notify = MiniNotify.make_notify()
vim.keymap.set('n', '<leader>un', MiniNotify.show_history, { desc = 'Historique des notifications' })

require('mini.statusline').setup { use_icons = true }

-- ── which-key ────────────────────────────────────────────────────────────
local wk = require 'which-key'
wk.setup { preset = 'helix', delay = 300 }
wk.add {
  { '<leader>b', group = 'Buffers' },
  { '<leader>c', group = 'Code' },
  { '<leader>d', group = 'Debug' },
  { '<leader>f', group = 'Fichiers' },
  { '<leader>g', group = 'Git' },
  { '<leader>h', group = 'Harpoon' },
  { '<leader>P', group = 'Plugins' },
  { '<leader>q', group = 'Session' },
  { '<leader>s', group = 'Recherche' },
  { '<leader>t', group = 'Tests' },
  { '<leader>u', group = 'UI / Toggles' },
  { '<leader>x', group = 'Diagnostics / Quickfix' },
  { 'gr', group = 'LSP (natif)' },
}
vim.keymap.set('n', '<leader>?', function() wk.show { global = false } end, { desc = 'Keymaps du buffer' })

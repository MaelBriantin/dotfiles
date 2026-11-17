local o = vim.o

-- Affichage
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes'
o.scrolloff = 10
o.sidescrolloff = 8
o.wrap = false
o.breakindent = true
o.showmode = false -- déjà dans la statusline
o.termguicolors = true
o.winborder = 'rounded' -- bordure par défaut de toutes les fenêtres flottantes (0.11+)
o.pumborder = 'rounded' -- bordure du menu popup (0.12)
o.list = true
o.listchars = 'tab:» ,trail:·,nbsp:␣'
o.fillchars = 'eob: ,fold: ,foldsep: '
o.laststatus = 3 -- une seule statusline globale
o.cmdheight = 1

-- Édition
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.smartindent = true
o.undofile = true
o.confirm = true
o.mouse = 'a'
o.virtualedit = 'block'

-- Recherche
o.ignorecase = true
o.smartcase = true
o.inccommand = 'split'
if vim.fn.executable 'rg' == 1 then
  o.grepprg = 'rg --vimgrep --smart-case'
  o.grepformat = '%f:%l:%c:%m'
end

-- Fenêtres
o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'

-- Timing
o.updatetime = 250
o.timeoutlen = 300

-- Folds via treesitter (ouverts par défaut)
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldtext = ''
o.foldlevel = 99
o.foldlevelstart = 99

-- Complétion : le menu natif est remplacé par blink.cmp
o.completeopt = 'menuone,noselect,popup,fuzzy'

-- Charge .nvim.lua / .exrc locaux au projet (avec confirmation, cf :h trust)
o.exrc = true

-- Presse-papier système, chargé après le démarrage (évite de ralentir le boot)
vim.schedule(function() o.clipboard = 'unnamedplus' end)

-- Diagnostics
vim.diagnostic.config {
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = { source = 'if_many' },
  virtual_text = { spacing = 2, source = 'if_many' },
  -- virtual_lines : toggle avec <leader>uv (affiche le diagnostic sous la ligne)
  virtual_lines = false,
  jump = { float = true }, -- ]d / [d ouvrent le flottant
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
}

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'ibhagwan/fzf-lua',
  gh 'stevearc/oil.nvim',
  gh('ThePrimeagen/harpoon', { version = 'harpoon2' }),
  gh 'folke/flash.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh('esmuellert/codediff.nvim', { version = vim.version.range '4.*' }),
  gh 'folke/todo-comments.nvim',
}

local map = vim.keymap.set

-- ── mini.nvim (édition) ──────────────────────────────────────────────────
-- Text objects enrichis : af/if (fonction), ac/ic (classe), aa/ia (argument),
-- ao/io (bloc), + quotes, brackets, etc. Basés sur treesitter.
local ai = require 'mini.ai'
ai.setup {
  n_lines = 500,
  custom_textobjects = {
    f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' },
    o = ai.gen_spec.treesitter {
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    },
  },
}
-- Surround préfixé par `gs` (laisse `s` libre pour flash) :
-- gsa (add) · gsd (delete) · gsr (replace) · gsf / gsF (find) · gsh (highlight)
require('mini.surround').setup {
  mappings = { add = 'gsa', delete = 'gsd', replace = 'gsr', find = 'gsf', find_left = 'gsF', highlight = 'gsh', update_n_lines = 'gsn' },
}
require('mini.pairs').setup()
require('mini.bracketed').setup() -- ]f [f fichiers, ]t [t treesitter, ]x [x conflits, etc.
require('mini.splitjoin').setup() -- gS : split/join arguments

-- ── fzf-lua : fuzzy finder ───────────────────────────────────────────────
local fzf = require 'fzf-lua'
fzf.setup {
  'default-title',
  winopts = { height = 0.85, width = 0.85, preview = { layout = 'flex', flip_columns = 140 } },
  keymap = { fzf = { ['ctrl-q'] = 'select-all+accept' } }, -- ctrl-q → tout en quickfix
  lsp = { code_actions = { previewer = 'codeaction_native' } },
}
fzf.register_ui_select() -- vim.ui.select passe par fzf-lua

map('n', '<leader><leader>', fzf.files, { desc = 'Fichiers' })
map('n', '<leader>,', fzf.buffers, { desc = 'Buffers' })
map('n', '<leader>/', fzf.live_grep_native, { desc = 'Grep (projet)' })
map('n', '<leader>ff', fzf.files, { desc = 'Fichiers' })
map('n', '<leader>fr', fzf.oldfiles, { desc = 'Fichiers récents' })
map('n', '<leader>fc', function() fzf.files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Fichiers de config nvim' })
map('n', '<leader>sg', fzf.live_grep_native, { desc = 'Grep' })
map({ 'n', 'x' }, '<leader>sw', fzf.grep_cword, { desc = 'Grep mot / sélection' })
map('n', '<leader>sb', fzf.blines, { desc = 'Lignes du buffer' })
map('n', '<leader>sh', fzf.helptags, { desc = 'Aide' })
map('n', '<leader>sk', fzf.keymaps, { desc = 'Keymaps' })
map('n', '<leader>sc', fzf.commands, { desc = 'Commandes' })
map('n', '<leader>sd', fzf.diagnostics_document, { desc = 'Diagnostics (buffer)' })
map('n', '<leader>sD', fzf.diagnostics_workspace, { desc = 'Diagnostics (workspace)' })
map('n', '<leader>sr', fzf.resume, { desc = 'Reprendre la dernière recherche' })
map('n', '<leader>sq', fzf.quickfix, { desc = 'Quickfix' })
map('n', '<leader>ss', fzf.lsp_document_symbols, { desc = 'Symboles (buffer)' })
map('n', '<leader>sS', fzf.lsp_live_workspace_symbols, { desc = 'Symboles (workspace)' })
map('n', '<leader>st', '<cmd>TodoFzfLua<CR>', { desc = 'TODO / FIXME' })
map('n', '<leader>gs', fzf.git_status, { desc = 'Git status' })
map('n', '<leader>gc', fzf.git_bcommits, { desc = 'Commits du buffer' })
map('n', '<leader>gC', fzf.git_commits, { desc = 'Commits' })
map('n', '<leader>gb', fzf.git_branches, { desc = 'Branches' })

-- ── oil.nvim : explorateur = un buffer éditable ──────────────────────────
-- Renommer / déplacer / supprimer des fichiers en éditant le texte, puis :w
require('oil').setup {
  default_file_explorer = true,
  view_options = { show_hidden = true },
  keymaps = { ['q'] = 'actions.close', ['<C-h>'] = false, ['<C-l>'] = false, ['<C-r>'] = 'actions.refresh' },
}
map('n', '-', '<cmd>Oil<CR>', { desc = 'Dossier parent (oil)' })
map('n', '<leader>e', function() require('oil').toggle_float() end, { desc = 'Explorateur flottant' })

-- ── Harpoon : accès instantané à 4-5 fichiers clés ──────────────────────
local harpoon = require 'harpoon'
harpoon:setup()
map('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon : ajouter' })
map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon : menu' })
for i = 1, 5 do
  map('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon : fichier ' .. i })
end

-- ── flash.nvim : saut rapide ─────────────────────────────────────────────
require('flash').setup { modes = { search = { enabled = false } } }
map({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
map({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter (sélection)' })
map('o', 'r', function() require('flash').remote() end, { desc = 'Flash remote' })

-- ── Review de code (codediff) ────────────────────────────────────────────
-- Explorateur des fichiers modifiés + diff côte à côte façon VSCode.
-- Le panneau de droite EST le fichier de travail : on corrige à la volée.
-- Dans la vue : ]f / [f fichier suivant/précédent · ]c / [c hunk · - stage/unstage
--               g? aide · q quitter
require('codediff').setup {}
map('n', '<leader>gv', '<cmd>CodeDiff<CR>', { desc = 'Review : changements en cours' })
map('n', '<leader>gV', '<cmd>CodeDiff --staged<CR>', { desc = 'Review : changements stagés' })
map('n', '<leader>gm', function()
  local base = vim.trim(vim.fn.system 'git rev-parse --abbrev-ref origin/HEAD 2>/dev/null')
  vim.cmd('CodeDiff ' .. (vim.v.shell_error == 0 and base or 'main'))
end, { desc = 'Review : branche vs main' })
map('n', '<leader>gh', '<cmd>CodeDiff history<CR>', { desc = 'Review : historique' })

-- ── Git ──────────────────────────────────────────────────────────────────
require('gitsigns').setup {
  current_line_blame_opts = { delay = 300 },
  on_attach = function(buf)
    local gs = require 'gitsigns'
    local function bmap(mode, l, r, desc) map(mode, l, r, { buffer = buf, desc = desc }) end
    bmap('n', ']h', function() gs.nav_hunk 'next' end, 'Hunk suivant')
    bmap('n', '[h', function() gs.nav_hunk 'prev' end, 'Hunk précédent')
    bmap('n', '<leader>gp', gs.preview_hunk_inline, 'Prévisualiser le hunk')
    bmap({ 'n', 'x' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', 'Reset hunk')
    bmap({ 'n', 'x' }, '<leader>ga', ':Gitsigns stage_hunk<CR>', 'Stage / unstage hunk')
    bmap('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
    bmap('n', '<leader>gB', function() gs.blame_line { full = true } end, 'Blame ligne')
    bmap('n', '<leader>ub', gs.toggle_current_line_blame, 'Toggle blame inline')
    bmap('n', '<leader>gd', gs.diffthis, 'Diff du fichier')
    bmap({ 'o', 'x' }, 'ih', gs.select_hunk, 'Hunk (text object)')
  end,
}

-- lazygit dans un onglet terminal (se ferme à la sortie)
map('n', '<leader>gg', function()
  vim.cmd 'tabnew'
  vim.fn.jobstart({ 'lazygit' }, {
    term = true,
    on_exit = function()
      vim.schedule(function() pcall(vim.cmd.tabclose) end)
    end,
  })
  vim.cmd.startinsert()
end, { desc = 'Lazygit' })

-- ── TODO / FIXME / HACK surlignés ────────────────────────────────────────
require('todo-comments').setup { signs = false }
map('n', ']T', function() require('todo-comments').jump_next() end, { desc = 'TODO suivant' })
map('n', '[T', function() require('todo-comments').jump_prev() end, { desc = 'TODO précédent' })

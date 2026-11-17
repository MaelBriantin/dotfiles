-- Keymaps génériques (hors plugins). Les keymaps de plugins sont dans
-- leur fichier respectif sous lua/plugins/.
--
-- Rappel des defaults natifs de Neovim 0.12 qu'on NE redéfinit PAS :
--   LSP   : grn (rename) · gra (code action) · grr (références) · gri (implémentation)
--           grt (type definition) · grx (codelens) · gO (symboles) · K (hover)
--           <C-s> en insert (signature) · gd / <C-]> (définition via tagfunc)
--   Diag  : ]d [d ]D [D (navigation) · <C-w>d (flottant sous le curseur)
--   Divers: ]q [q (quickfix) · ]b [b (buffers) · gc / gcc (commentaires)
--           [<Space> ]<Space> (ligne vide) · :Undotree · :restart

local map = vim.keymap.set

-- Efface la surbrillance de recherche
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Navigation entre splits
map('n', '<C-h>', '<C-w>h', { desc = 'Fenêtre gauche' })
map('n', '<C-j>', '<C-w>j', { desc = 'Fenêtre bas' })
map('n', '<C-k>', '<C-w>k', { desc = 'Fenêtre haut' })
map('n', '<C-l>', '<C-w>l', { desc = 'Fenêtre droite' })

-- Sortie du mode terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Quitter le mode terminal' })

-- Déplacer des lignes en visuel
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Descendre la sélection', silent = true })
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Monter la sélection', silent = true })

-- Garder le curseur centré
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Coller sans écraser le registre
map('x', '<leader>p', '"_dP', { desc = 'Coller sans perdre le registre' })

-- Buffers
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Fermer le buffer' })
map('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', { desc = 'Fermer les autres buffers' })

-- Quickfix / location list
map('n', '<leader>xq', function()
  local open = vim.iter(vim.fn.getwininfo()):any(function(w) return w.quickfix == 1 end)
  vim.cmd(open and 'cclose' or 'copen')
end, { desc = 'Toggle quickfix' })
map('n', '<leader>xd', vim.diagnostic.setloclist, { desc = 'Diagnostics → loclist' })

-- Toggles UI
map('n', '<leader>uv', function()
  local cfg = vim.diagnostic.config() or {}
  local on = not cfg.virtual_lines
  vim.diagnostic.config { virtual_lines = on and { current_line = true } or false, virtual_text = not on }
end, { desc = 'Toggle diagnostics en lignes virtuelles' })
map('n', '<leader>ud', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = 'Toggle diagnostics' })
map('n', '<leader>uw', '<cmd>set wrap!<CR>', { desc = 'Toggle wrap' })
map('n', '<leader>uu', '<cmd>Undotree<CR>', { desc = 'Undotree (natif)' })

-- Redémarrer Neovim en gardant la session (0.12)
map('n', '<leader>qr', '<cmd>restart<CR>', { desc = 'Redémarrer Neovim' })
map('n', '<leader>qq', '<cmd>qa<CR>', { desc = 'Quitter' })

-- Gestion des plugins (vim.pack)
map('n', '<leader>Pu', function() vim.pack.update() end, { desc = 'Mettre à jour les plugins' })
map('n', '<leader>Ps', function() vim.pack.update(nil, { offline = true }) end, { desc = 'État des plugins' })
map('n', '<leader>Pc', function()
  local unused = vim.iter(vim.pack.get()):filter(function(p) return not p.active end):map(function(p) return p.spec.name end):totable()
  if #unused == 0 then return vim.notify 'Aucun plugin orphelin' end
  if vim.fn.confirm('Supprimer : ' .. table.concat(unused, ', ') .. ' ?', '&Oui\n&Non', 2) == 1 then vim.pack.del(unused) end
end, { desc = 'Nettoyer les plugins inutilisés' })

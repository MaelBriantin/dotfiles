local group = vim.api.nvim_create_augroup('user-config', { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Surbrillance du texte copié
autocmd('TextYankPost', {
  group = group,
  callback = function() vim.hl.on_yank { timeout = 150 } end,
})

-- Revenir à la dernière position connue dans le fichier
autocmd('BufReadPost', {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines and vim.bo[ev.buf].filetype ~= 'gitcommit' then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Recharger les fichiers modifiés hors de nvim (ex : par un agent IA).
-- 'autoread' est actif par défaut ; checktime déclenche la vérification.
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermLeave' }, {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == '' and vim.bo.buftype == '' then vim.cmd 'checktime' end
  end,
})

-- Rééquilibrer les splits quand le terminal est redimensionné
autocmd('VimResized', { group = group, command = 'tabdo wincmd =' })

-- Fermer certaines fenêtres utilitaires avec `q`
autocmd('FileType', {
  group = group,
  pattern = { 'help', 'qf', 'man', 'checkhealth', 'nvim-pack', 'neotest-output', 'neotest-output-panel', 'neotest-summary' },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = ev.buf, silent = true })
  end,
})

-- Indentation par langage (les autres héritent de 2 espaces)
autocmd('FileType', {
  group = group,
  pattern = { 'php', 'rust', 'zig' },
  callback = function()
    vim.bo.shiftwidth, vim.bo.tabstop, vim.bo.softtabstop = 4, 4, 4
  end,
})
autocmd('FileType', {
  group = group,
  pattern = 'go',
  callback = function()
    vim.bo.expandtab, vim.bo.shiftwidth, vim.bo.tabstop = false, 4, 4
  end,
})

-- Créer les dossiers manquants à l'écriture
autocmd('BufWritePre', {
  group = group,
  callback = function(ev)
    if ev.match:match '^%w%w+:[\\/][\\/]' then return end
    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ':p:h'), 'p')
  end,
})

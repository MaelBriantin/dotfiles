-- neotest : lancer / déboguer les tests depuis l'éditeur, résultats inline.
vim.pack.add {
  gh 'nvim-neotest/nvim-nio',
  gh 'nvim-neotest/neotest',
  -- adapters
  gh 'marilari88/neotest-vitest',
  gh 'nvim-neotest/neotest-jest',
  gh('fredrikaverpil/neotest-golang', { version = vim.version.range '2.*' }),
  gh 'olimorris/neotest-phpunit',
  gh 'V13Axel/neotest-pest',
  -- Rust : adapter fourni par rustaceanvim
  -- Zig : neotest-zig est cassé depuis Zig 0.15+ → fallback maison en bas de fichier
}

local neotest = require 'neotest'

neotest.setup {
  adapters = {
    require 'neotest-vitest',
    require 'neotest-jest' {
      jestCommand = 'npx jest',
      cwd = function() return vim.fn.getcwd() end,
    },
    require 'neotest-golang' { runner = vim.fn.executable 'gotestsum' == 1 and 'gotestsum' or 'go' },
    -- Pest est prioritaire si le projet l'utilise (vendor/bin/pest), sinon PHPUnit
    require 'neotest-pest',
    require 'neotest-phpunit',
    require 'rustaceanvim.neotest',
  },
  status = { virtual_text = true },
  output = { open_on_run = false },
  quickfix = { open = false },
}

local map = function(keys, fn, desc) vim.keymap.set('n', keys, fn, { desc = 'Test : ' .. desc }) end

map('<leader>tt', function() neotest.run.run() end, 'le plus proche')
map('<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, 'fichier')
map('<leader>tA', function() neotest.run.run(vim.uv.cwd()) end, 'tout le projet')
map('<leader>tl', function() neotest.run.run_last() end, 'relancer le dernier')
map('<leader>td', function() neotest.run.run { strategy = 'dap' } end, 'déboguer le plus proche')
map('<leader>tx', function() neotest.run.stop() end, 'stop')
map('<leader>ta', function() neotest.run.attach() end, 'attacher')
map('<leader>ts', function() neotest.summary.toggle() end, 'arbre des tests')
map('<leader>to', function() neotest.output.open { enter = true, auto_close = true } end, 'sortie (flottant)')
map('<leader>tO', function() neotest.output_panel.toggle() end, 'panneau de sortie')
map('<leader>tw', function() neotest.watch.toggle(vim.fn.expand '%') end, 'watch fichier')
map(']n', function() neotest.jump.next { status = 'failed' } end, 'échec suivant')
map('[n', function() neotest.jump.prev { status = 'failed' } end, 'échec précédent')

-- ── Zig : fallback sans neotest ─────────────────────────────────────────
-- Mêmes raccourcis, exécutés dans un split terminal.
--   <leader>tt : test sous le curseur (zig test fichier --test-filter "nom")
--   <leader>tf : tous les tests du fichier
--   <leader>tA : zig build test
local last_zig_cmd
local function zig_run(cmd)
  last_zig_cmd = cmd
  vim.cmd 'botright 15split'
  vim.fn.jobstart(cmd, { term = true })
  vim.cmd.startinsert()
end
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zig',
  callback = function(ev)
    local function bmap(keys, fn, desc) vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = 'Test (zig) : ' .. desc }) end
    bmap('<leader>tt', function()
      local lnum = vim.fn.search([[^\s*test\s\+"]], 'bcnW')
      local name = lnum > 0 and vim.fn.getline(lnum):match 'test%s+"(.-)"' or nil
      if not name then return vim.notify('Aucun test au-dessus du curseur', vim.log.levels.WARN) end
      zig_run { 'zig', 'test', vim.fn.expand '%:p', '--test-filter', name }
    end, 'le plus proche')
    bmap('<leader>tf', function() zig_run { 'zig', 'test', vim.fn.expand '%:p' } end, 'fichier')
    bmap('<leader>tA', function() zig_run { 'zig', 'build', 'test', '--summary', 'all' } end, 'zig build test')
    bmap('<leader>tl', function()
      if last_zig_cmd then zig_run(last_zig_cmd) end
    end, 'relancer le dernier')
  end,
})

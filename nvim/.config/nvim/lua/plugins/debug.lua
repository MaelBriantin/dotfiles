-- nvim-dap + nvim-dap-view : debugger. Adapters installés par mason.
-- Go : delve · Rust/Zig : codelldb (rustaceanvim le détecte seul)
-- TS/JS : js-debug-adapter · PHP : php-debug-adapter (Xdebug, port 9003)
vim.pack.add {
  gh 'mfussenegger/nvim-dap',
  gh 'igorlfs/nvim-dap-view',
  gh 'leoluz/nvim-dap-go',
}

local dap = require 'dap'
local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'
local mason_pkg = vim.fn.stdpath 'data' .. '/mason/packages/'

require('dap-view').setup { auto_toggle = true } -- s'ouvre/ferme avec la session
require('dap-go').setup()

-- ── codelldb (Zig, C, Rust hors rustaceanvim) ───────────────────────────
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = { command = mason_bin .. 'codelldb', args = { '--port', '${port}' } },
}
dap.configurations.zig = {
  {
    name = 'Lancer (zig-out/bin)',
    type = 'codelldb',
    request = 'launch',
    program = function() return vim.fn.input('Exécutable : ', vim.fn.getcwd() .. '/zig-out/bin/', 'file') end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

-- ── JavaScript / TypeScript (Node) ──────────────────────────────────────
for _, t in ipairs { 'pwa-node', 'node' } do
  dap.adapters[t] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = { mason_pkg .. 'js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
    },
  }
end
for _, ft in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
  dap.configurations[ft] = {
    { type = 'pwa-node', request = 'launch', name = 'Lancer le fichier', program = '${file}', cwd = '${workspaceFolder}' },
    { type = 'pwa-node', request = 'attach', name = 'Attacher (--inspect)', processId = require('dap.utils').pick_process, cwd = '${workspaceFolder}' },
  }
end

-- ── PHP (Xdebug) ────────────────────────────────────────────────────────
dap.adapters.php = { type = 'executable', command = mason_bin .. 'php-debug-adapter' }
dap.configurations.php = {
  { type = 'php', request = 'launch', name = 'Écouter Xdebug', port = 9003 },
}

-- Les .vscode/launch.json du projet sont lus automatiquement par nvim-dap.

-- ── Signes ──────────────────────────────────────────────────────────────
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'Visual' })

-- ── Keymaps ─────────────────────────────────────────────────────────────
local map = function(keys, fn, desc) vim.keymap.set('n', keys, fn, { desc = 'Debug : ' .. desc }) end
map('<leader>db', dap.toggle_breakpoint, 'breakpoint')
map('<leader>dB', function() dap.set_breakpoint(vim.fn.input 'Condition : ') end, 'breakpoint conditionnel')
map('<leader>dc', dap.continue, 'continuer / démarrer')
map('<leader>dC', dap.run_to_cursor, 'jusqu’au curseur')
map('<leader>di', dap.step_into, 'step into')
map('<leader>do', dap.step_over, 'step over')
map('<leader>dO', dap.step_out, 'step out')
map('<leader>dr', dap.restart, 'redémarrer')
map('<leader>dt', dap.terminate, 'terminer')
map('<leader>dv', '<cmd>DapViewToggle<CR>', 'toggle vue')
map('<leader>dw', '<cmd>DapViewWatch<CR>', 'watch expression')
map('<F5>', dap.continue, 'continuer')
map('<F10>', dap.step_over, 'step over')
map('<F11>', dap.step_into, 'step into')
map('<F12>', dap.step_out, 'step out')

vim.pack.add {
  gh 'stevearc/conform.nvim',
  gh 'mfussenegger/nvim-lint',
}

-- ── Formatage (conform) ─────────────────────────────────────────────────
-- Format à la sauvegarde. Désactiver : <leader>uf (buffer) / <leader>uF (global)
local js = { 'prettierd', 'prettier', stop_after_first = true }
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = js,
    javascriptreact = js,
    typescript = js,
    typescriptreact = js,
    vue = js,
    svelte = js,
    css = js,
    scss = js,
    html = js,
    json = js,
    jsonc = js,
    yaml = js,
    markdown = js,
    go = { 'goimports', 'gofumpt' },
    -- Laravel Pint si présent dans le projet, sinon php-cs-fixer
    php = { 'pint', 'php_cs_fixer', stop_after_first = true },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    zig = { 'zigfmt' },
    toml = { 'taplo' },
    ['_'] = { 'trim_whitespace' },
  },
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = function(buf)
    if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
    return { timeout_ms = 1000 }
  end,
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- gq utilise conform

vim.keymap.set({ 'n', 'x' }, '<leader>cf', function() require('conform').format { async = true } end, { desc = 'Formater' })
vim.keymap.set('n', '<leader>uf', function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify('Autoformat (buffer) : ' .. (vim.b.disable_autoformat and 'off' or 'on'))
end, { desc = 'Toggle autoformat (buffer)' })
vim.keymap.set('n', '<leader>uF', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('Autoformat (global) : ' .. (vim.g.disable_autoformat and 'off' or 'on'))
end, { desc = 'Toggle autoformat (global)' })

-- ── Linting (nvim-lint) — en complément des LSP ─────────────────────────
-- (ESLint passe par le LSP eslint ; clippy par rust-analyzer)
local lint = require 'lint'
lint.linters_by_ft = {
  go = { 'golangcilint' },
  php = { 'phpstan' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
  callback = function()
    -- ignore_errors : silencieux si le binaire du linter est absent
    if vim.bo.modifiable then lint.try_lint(nil, { ignore_errors = true }) end
  end,
})

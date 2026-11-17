-- Copilot via le support natif de Neovim 0.12 : copilot-language-server
-- (installé par mason) + vim.lsp.inline_completion. Aucun plugin requis.
--
-- Première utilisation : ouvrir un fichier puis `:LspCopilotSignIn`.
-- Pour désactiver complètement : vim.g.copilot_enabled = false

if vim.g.copilot_enabled == false then return end

if vim.fn.executable 'copilot-language-server' == 1 then
  vim.lsp.enable 'copilot'
else
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    once = true,
    callback = function()
      if vim.fn.executable 'copilot-language-server' == 1 then vim.lsp.enable 'copilot' end
    end,
  })
end

vim.lsp.inline_completion.enable()

-- <M-l> accepte la suggestion (ghost text) ; <M-]> / <M-[> pour cycler.
vim.keymap.set('i', '<M-l>', function()
  if not vim.lsp.inline_completion.get() then return '<M-l>' end
end, { expr = true, desc = 'Copilot : accepter' })
vim.keymap.set('i', '<M-]>', function() vim.lsp.inline_completion.select { count = 1 } end, { desc = 'Copilot : suivante' })
vim.keymap.set('i', '<M-[>', function() vim.lsp.inline_completion.select { count = -1 } end, { desc = 'Copilot : précédente' })
vim.keymap.set('n', '<leader>ua', function() vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled()) end, { desc = 'Toggle Copilot' })

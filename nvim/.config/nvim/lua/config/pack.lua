-- Hooks post-install / post-update pour vim.pack.
-- Doit être chargé avant le tout premier vim.pack.add().

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-pack-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    -- Recompiler les parsers treesitter après une mise à jour du plugin
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

--- Raccourci : 'owner/repo' -> URL GitHub
---@param repo string
---@param spec? table
function _G.gh(repo, spec) return vim.tbl_extend('force', { src = 'https://github.com/' .. repo }, spec or {}) end

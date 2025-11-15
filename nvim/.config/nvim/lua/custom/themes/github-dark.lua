-- GitHub Dark Dimmed theme configuration
return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup {
      options = {
        transparent = false,
      },
    }
    vim.cmd 'colorscheme github_dark_dimmed'
    -- Custom highlight groups for menus and popups
    -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#2d333b' })
    -- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#2d333b', fg = '#444c56' })
    -- vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#2d333b', fg = '#adbac7' })
    -- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#373e47', fg = '#adbac7' })
    -- vim.api.nvim_set_hl(0, 'PmenuBorder', { bg = '#2d333b', fg = '#444c56' })
  end,
}

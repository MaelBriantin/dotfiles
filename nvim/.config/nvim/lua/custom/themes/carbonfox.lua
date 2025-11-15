-- Carbonfox theme configuration
return {
  'EdenEast/nightfox.nvim',
  name = 'nightfox',
  lazy = true,
  priority = 1000,
  config = function()
    require('nightfox').setup {
      options = {
        transparent = true,
      },
    }
    vim.cmd 'colorscheme carbonfox'
  end,
}

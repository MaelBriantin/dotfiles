-- Nordic theme configuration
return {
  'AlexvZyl/nordic.nvim',
  lazy = true,
  priority = 1000,
  config = function()
    require('nordic').setup {
      transparent = {
        bg = true,
        float = false,
      },
    }
    vim.cmd.colorscheme 'nordic'
  end,
}

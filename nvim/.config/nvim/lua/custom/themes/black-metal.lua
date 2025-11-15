-- Black Metal theme configuration
return {
  'metalelf0/black-metal-theme-neovim',
  lazy = true,
  priority = 1000,
  config = function()
    require('black-metal').setup {
      theme = 'bathory',
      transparent = false,
    }
    require('black-metal').load()
  end,
}

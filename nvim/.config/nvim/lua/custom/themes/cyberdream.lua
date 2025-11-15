-- Cyberdream theme configuration
return {
  'scottmckendry/cyberdream.nvim',
  lazy = true,
  priority = 1000,
  config = function()
    require('cyberdream').setup {
      transparent = true,
      borderless_pickers = true,
      hide_fillchars = true,
      extensions = {
        telescope = true,
        notify = true,
        mini = true,
      },
    }
    vim.cmd 'colorscheme cyberdream'
  end,
}

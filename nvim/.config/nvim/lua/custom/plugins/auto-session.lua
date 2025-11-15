return {
  'rmagatti/auto-session',
  lazy = false,
  enabled = true,
  config = function()
    require('auto-session').setup {
      log_level = 'error',
      auto_session_suppress_dirs = { '~/', '~/Downloads', '~/Documents', '/' },
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
    }

    vim.keymap.set('n', '<leader>qd', '<cmd>AutoSession delete<cr>', { desc = 'Session [D]elete' })
    vim.keymap.set('n', '<leader>qq', '<cmd>qa!<cr>', { desc = '[Q]uit without saving' })
    vim.keymap.set('n', '<leader>qw', '<cmd>wqa<cr>', { desc = 'Save session and [Q]uit' })
  end,
}

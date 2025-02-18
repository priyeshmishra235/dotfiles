return {
  'yutkat/confirm-quit.nvim',
  event = 'CmdlineEnter',
  opts = {},
  config = function()
    vim.opt.confirm = true

    local confirm_quit = require 'confirm-quit'

    vim.keymap.set('n', '<leader>q', confirm_quit.confirm_quit)
    vim.keymap.set('n', '<leader>Q', confirm_quit.confirm_quit_all)
  end,
}

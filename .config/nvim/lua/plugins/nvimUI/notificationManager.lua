return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  config = function()
    vim.opt.termguicolors = true -- Ensure true colors

    local notify = require 'notify'
    vim.notify = notify -- Set notify globally
    notify.setup {
      background_colour = '#000000',
      fps = 60,
      icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
      },
      max_width = 50,  -- Maximum width of the notification window
      max_height = 20, -- Maximum height of the notification window      level =
      2,
      minimum_width = 50,
      render = 'wrapped-compact',
      stages = 'fade_in_slide_out',
      time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
      },
      timeout = 5000,
      top_down = true,
    }

    if pcall(require, 'telescope') then
      require('telescope').load_extension 'notify'
    end
  end,
}

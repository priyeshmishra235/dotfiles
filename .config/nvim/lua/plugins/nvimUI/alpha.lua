return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.header.val = {
      [[                                                                      ]],
      [[      ████ ██████           █████      ██                     ]],
      [[     ███████████             █████                             ]],
      [[     █████████ ███████████████████ ███   ███████████   ]],
      [[    █████████  ███    █████████████ █████ ██████████████   ]],
      [[   █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[ ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                            - SWE Priyesh Mishra      ]],
    }
    -- Custom Buttons
    dashboard.section.buttons.val = {
      dashboard.button('f', '  Find File', ':Telescope find_files <CR>'),
      dashboard.button('n', '  New File', ':ene <BAR> startinsert <CR>'),
      dashboard.button('r', '  Recent Files', ':Telescope oldfiles <CR>'),
      dashboard.button('q', '  Quit NVIM', ':qa<CR>'),
    }

    -- Fortune Quote at the Bottom
    local fortune = require 'alpha.fortune'
    dashboard.section.footer.val = fortune()

    -- Styling
    dashboard.section.header.opts.hl = 'Type'
    dashboard.section.buttons.opts.hl = 'Keyword'
    dashboard.section.footer.opts.hl = 'Comment'

    alpha.setup(dashboard.opts)
  end,
}

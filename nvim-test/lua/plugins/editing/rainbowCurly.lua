return {
  'HiPhish/rainbow-delimiters.nvim',

  -- @type rainbow_delimiters.config
  config = function()
    require('rainbow-delimiters.setup').setup {
      strategy = {
        [''] = require('rainbow-delimiters').strategy['global'],
        vim = require('rainbow-delimiters').strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      priority = {
        [''] = 110,
        lua = 210,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}

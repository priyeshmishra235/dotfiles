return {
  'ellisonleao/carbon-now.nvim',
  lazy = true,
  cmd = 'CarbonNow',
  opts = {
    base_url = 'https://carbon.now.sh/',
    options = {
      bg = 'gray',
      drop_shadow_blur = '68px',
      drop_shadow = false,
      drop_shadow_offset_y = '20px',
      font_family = 'Hack',
      font_size = '18px',
      line_height = '133%',
      line_numbers = true,
      theme = 'monokai',
      titlebar = 'Made with carbon-now.nvim',
      watermark = false,
      width = '680',
      window_theme = 'sharp',
      padding_horizontal = '0px',
      padding_vertical = '0px',
    },
  },
  config = function(_, opts)
    require('carbon-now').setup(opts)
    vim.keymap.set('v', '<leader>cn', ':CarbonNow<CR>', {
      silent = true,
      desc = 'Generate a Carbon image from selected code',
    })
  end,
}

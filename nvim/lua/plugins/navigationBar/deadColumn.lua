return {
  'Bekaboo/deadcolumn.nvim',
  event = 'BufReadPost',
  config = function()
    vim.opt.colorcolumn = '80'
    require('deadcolumn').setup {
      scope = 'line',
      modes = function(mode)
        return mode:find '^[iRss\x13]' ~= nil
      end,
      blending = {
        threshold = 0.5,
        colorcode = '#000000',
        hlgroup = { 'Normal', 'bg' },
      },
      warning = {
        alpha = 0.4,
        offset = 0,
        colorcode = '#FF0000',
        hlgroup = { 'Error', 'bg' },
      },
      extra = {
        follow_tw = nil,
      },
    }
  end,
}

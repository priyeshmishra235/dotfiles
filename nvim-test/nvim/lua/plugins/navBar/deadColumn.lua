return {
  'Bekaboo/deadcolumn.nvim',
  event = 'BufReadPost', -- Load when a file is opened
  config = function()
    vim.opt.colorcolumn = '80' -- Highlights the 80th column
    require('deadcolumn').setup {
      scope = 'line', ---@type string|fun(): integer
      ---@type string[]|boolean|fun(mode: string): boolean
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
        ---@type string|integer
        follow_tw = nil,
      },
    }
  end,
}

return {
  'gbprod/yanky.nvim',
  keys = {
    { '<leader>y', '<cmd>YankyRingHistory<cr>', mode = { 'n', 'x' }, desc = 'Yank Ring History (Yanky)' },
    { 'y',         '<Plug>(YankyYank)',         mode = { 'n', 'x' }, desc = 'Yank (Yanky)' },
    { 'p',         '<Plug>(YankyPutAfter)',     mode = { 'n', 'x' }, desc = 'Put After (Yanky)' },
    { 'P',         '<Plug>(YankyPutBefore)',    mode = { 'n', 'x' }, desc = 'Put Before (Yanky)' },
  },
  opts = {
    highlight = {
      on_put  = true,
      on_yank = true,
      timer   = 100,
    },
  },
}

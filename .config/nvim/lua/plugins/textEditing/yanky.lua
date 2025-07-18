return {
  'gbprod/yanky.nvim',
  event = 'VeryLazy',
  enabled = true,
  keys = {
    { '<leader>y', '<cmd>YankyRingHistory<cr>', mode = { 'n', 'x' }, desc = 'Yank Ring History (Yanky)' },
    { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank (Yanky)' },
    -- { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put After (Yanky)' },
    -- { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put Before (Yanky)' },
    -- { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'GPut After (Yanky)' },
    -- { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'GPut Before (Yanky)' },
    -- { '<right>y', '<Plug>(YankyCycleForward)', desc = 'Cycle Forward (Yanky)' },
    -- { '<left>y', '<Plug>(YankyCycleBackward)', desc = 'Cycle Backward (Yanky)' },
    -- { '<right>p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indent After Linewise (Yanky)' },
    -- { '<left>p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indent Before Linewise (Yanky)' },
    -- { '<right>P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put Indent After Linewise (Yanky)' },
    -- { '<left>P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put Indent Before Linewise (Yanky)' },
    -- { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put Indent After Shift Right (Yanky)' },
    -- { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put Indent After Shift Left (Yanky)' },
    -- { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put Indent Before Shift Right (Yanky)' },
    -- { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put Indent Before Shift Left (Yanky)' },
    -- { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put After Filter (Yanky)' },
    -- { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put Before Filter (Yanky)' },
  },
  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 100,
    },
  },
}

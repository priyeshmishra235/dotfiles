return {
  'booperlv/nvim-gomove',
  event = 'VeryLazy',
  config = function()
    require('gomove').setup {
      map_defaults = false,
      -- whether or not to reindent lines moved vertically (true/false)
      reindent = true,
      -- whether or not to undojoin same direction moves (true/false)
      undojoin = true,
      -- whether to not to move past end column when moving blocks horizontally,
      -- (true/false)
      move_past_end_col = false,
    }

    -- Move text mappings
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    -- <S-...> → Shift + Key
    -- <A-...> → Alt + Key
    map('n', '<S-h>', '<Plug>GoNSMLeft', opts)
    map('n', '<S-j>', '<Plug>GoNSMDown', opts)
    map('n', '<S-k>', '<Plug>GoNSMUp', opts)
    map('n', '<S-l>', '<Plug>GoNSMRight', opts)

    map('x', '<S-h>', '<Plug>GoVSMLeft', opts)
    map('x', '<S-j>', '<Plug>GoVSMDown', opts)
    map('x', '<S-k>', '<Plug>GoVSMUp', opts)
    map('x', '<S-l>', '<Plug>GoVSMRight', opts)

    map('n', '<A-h>', '<Plug>GoNSDLeft', opts)
    map('n', '<A-j>', '<Plug>GoNSDDown', opts)
    map('n', '<A-k>', '<Plug>GoNSDUp', opts)
    map('n', '<A-l>', '<Plug>GoNSDRight', opts)

    map('x', '<A-h>', '<Plug>GoVSDLeft', opts)
    map('x', '<A-j>', '<Plug>GoVSDDown', opts)
    map('x', '<A-k>', '<Plug>GoVSDUp', opts)
    map('x', '<A-l>', '<Plug>GoVSDRight', opts)
  end,
}

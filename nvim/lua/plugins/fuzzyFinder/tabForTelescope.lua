return {
  'FabianWirth/search.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  mappings = {
    next = { { 'L', 'n' }, { '<Tab>', 'n' }, { '<Tab>', 'i' } },
    prev = { { 'H', 'n' }, { '<S-Tab>', 'n' }, { '<S-Tab>', 'i' } },
  },
}

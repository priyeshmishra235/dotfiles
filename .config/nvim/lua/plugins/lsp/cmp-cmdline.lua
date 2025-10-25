return {
  'hrsh7th/cmp-cmdline',
  event = 'CmdlineEnter',
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    local cmp = require('cmp')

    -- ":" command‑line completion
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'path' },
        { name = 'cmdline' },
      },
    })

    -- "/", "?" search completion
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }, -- optional, very light
      },
    })
  end,
}

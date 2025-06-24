return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    label = {
      reuse = 'all',
    },
    modes = {
      search = {
        enabled = true,
        highlight = { backdrop = true },
      },
      char = {
        jump_labels = true,
        keys = { 'f', 'F', 't', 'T' },
        char_actions = function(motion)
          return {
            [','] = 'next',
            [';'] = 'prev',
            [motion:lower()] = 'next',
            [motion:upper()] = 'prev',
          }
        end,
      },
      treesitter = {
        highlight = {
          backdrop = true,
        },
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      '<leader>fs',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      '<Space>fes',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Flash Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
}

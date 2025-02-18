return {
  'folke/twilight.nvim',
  opts = {
    {
      dimming = {
        alpha = 0.25, -- amount of dimming
        color = { 'Normal', '#ffffff' }, -- foreground color
        term_bg = '#000000', -- terminal background color
        inactive = false, -- dim other windows fully if true
      },
      context = 10, -- number of visible lines around the current line
      treesitter = true, -- use Treesitter for better visibility
      expand = { -- always fully expand these Treesitter nodes
        'function',
        'method',
        'table',
        'if_statement',
      },
      exclude = {}, -- exclude these filetypes
  },
  },
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>tt', ':Twilight<CR>', { noremap =
    true, silent = true }) -- Toggle Twilight
  end,
}

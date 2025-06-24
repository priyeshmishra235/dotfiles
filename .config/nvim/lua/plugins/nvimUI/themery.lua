return {
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      local themes = vim.fn.getcompletion('', 'color') -- Get all installed themes
      local themery = require 'themery'
      themery.setup {
        themes = themes,
        livePreview = true,
      }
    end,
  },

  -- { 'ellisonleao/gruvbox.nvim' },
  -- { 'Shatur/neovim-ayu' },
  -- { 'folke/tokyonight.nvim' },
  -- { 'catppuccin/nvim', name = 'catppuccin' },
  -- { 'sainnhe/everforest' },
  -- { 'EdenEast/nightfox.nvim' },
  -- { 'rebelot/kanagawa.nvim' },
  -- { 'navarasu/onedark.nvim' },
  -- { 'projekt0n/github-nvim-theme' },
  -- { 'Mofiqul/vscode.nvim' },
  -- { 'scottmckendry/cyberdream.nvim' },
  { 'Mofiqul/dracula.nvim' },
  -- { 'olimorris/onedarkpro.nvim' },
  { 'AlexvZyl/nordic.nvim' },
  -- { 'bluz71/vim-moonfly-colors', name = 'moonfly' },
  -- { 'tiagovla/tokyodark.nvim' },
  -- { 'Skalyaev/a-nvim-theme', name = 'aesthetic' },
  -- { 'rafamadriz/neon' },
}

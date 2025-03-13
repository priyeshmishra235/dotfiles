return {
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      local themes = vim.fn.getcompletion('', 'color') -- Get all installed themes

      local function should_apply_theme()
        local current_ft = vim.bo.filetype
        return current_ft ~= 'dashboard' and current_ft ~= 'alpha' -- Exclude dashboard-like filetypes
      end

      -- Hook into Themery to prevent applying themes on dashboard
      local themery = require 'themery'
      themery.setup {
        themes = themes,
        livePreview = true,
      }

      -- Override colorscheme command to check for dashboard before applying
      local original_cmd = vim.cmd.colorscheme
      vim.cmd.colorscheme = function(theme)
        if should_apply_theme() then
          original_cmd(theme) -- Only apply theme if not in dashboard
        end
      end
    end,
  },

  -- Install multiple themes
  { 'ellisonleao/gruvbox.nvim' },
  { 'Shatur/neovim-ayu' },
  { 'folke/tokyonight.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'sainnhe/everforest' },
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'navarasu/onedark.nvim' },
  { 'projekt0n/github-nvim-theme' },
  { 'Mofiqul/vscode.nvim' },
  { 'scottmckendry/cyberdream.nvim' },
  { 'Mofiqul/dracula.nvim' },
  { 'olimorris/onedarkpro.nvim' },
  { 'AlexvZyl/nordic.nvim' },
  { 'bluz71/vim-moonfly-colors', name = 'moonfly' },
  { 'tiagovla/tokyodark.nvim' },
  { 'Skalyaev/a-nvim-theme', name = 'aesthetic' },
  { 'rafamadriz/neon' },
}

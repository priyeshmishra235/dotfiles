return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    event = 'VeryLazy',
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- Auto indent line
    'vidocqh/auto-indent.nvim',
    event = 'VeryLazy',
    config = function()
      require('auto-indent').setup {
        lightmode = true,
        --Lightmode assumes tabstop and indentexpr not change
        -- within buffer's lifetime
        indentexpr = nil, -- Use vim.bo.indentexpr by default, see 'Custom
        --Indent
        --Evaluate Method'
        ignore_filetype = {}, -- Disable plugin for specific filetypes, e.g.
        --ignore_filetype = { 'javascript' },
      }
    end,
  },
  -- NoteTaking functionality
  -- {
  --   'nvim-neorg/neorg',
  --   lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  --   version = '*', -- Pin Neorg to the latest stable release
  --   config = true,
  -- },
  --
}

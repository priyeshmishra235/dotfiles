-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    --Without it, some snippet transformations won't work, especially
    --LSP-generated snippets that modify text dynamically.
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },

  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- Auto indent line
    'vidocqh/auto-indent.nvim',
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
  {
    'mg979/vim-visual-multi',
    -- Basic usage:
    --
    -- - Select words with Ctrl-N (like Ctrl-D in Sublime Text/VS Code)
    -- - Create cursors vertically with Ctrl-Down/Ctrl-Up
    -- - Select one character at a time with Shift-Arrows
    -- - Press n/N to get next/previous occurrence
    -- - Press [/] to select next/previous cursor
    -- - Press q to skip current and get next occurrence
    -- - Press Q to remove current cursor/selection
    -- - Start insert mode with i, a, I, A
    --
    -- Two main modes:
    --
    -- - In "cursor mode," commands work as they would in normal mode.
    -- - In "extend mode," commands work as they would in visual mode.
    --
    -- - Press Tab to switch between «cursor» and «extend» mode.
    --
    -- Most Vim commands work as expected (motions, `r` to replace characters, `~`
    -- to change case, etc).
  },
  -- NoteTaking functionality
  {
    'nvim-neorg/neorg',
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = '*', -- Pin Neorg to the latest stable release
    config = true,
  },
  --
  --[[{
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },]]
}

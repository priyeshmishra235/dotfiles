return {
  "xiyaowong/transparent.nvim",
  lazy = false, -- Ensure it loads immediately on startup
  priority = 1000, -- Load it before your colorscheme if possible
  config = function()
    require("transparent").setup({
      -- This ensures transparency is applied to all groups
      groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
        'Function', 'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr',
        'NonText', 'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine',
        'StatusLineNC', 'EndOfBuffer',
      },
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
        "FloatBorder",
        "TelescopeNormal",
        "TelescopeBorder",
      },
    })
    -- Force enable on start
    vim.cmd("TransparentEnable")
  end
}

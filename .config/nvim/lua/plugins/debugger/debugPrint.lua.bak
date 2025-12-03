return {
  "andrewferrier/debugprint.nvim",
  event = 'VeryLazy',
  opts = {
    keymaps = {
      normal = {
        plain_below = "dpp",
        plain_above = "dpP",
        variable_below = "dpv",
        variable_above = "dpV",
        -- variable_below_alwaysprompt = "",
        -- variable_above_alwaysprompt = "",
        textobj_below = "dpo",
        textobj_above = "dpO",
        toggle_comment_debug_prints = "dpc",
        delete_debug_prints = "dpd",
      },
      display_location = true,
      display_counter = true,
      display_snippet = true,
      highlight_lines = true,
      print_tag = "DEBUGPRINT",
      insert = {
        plain = "<C-G>p",
        variable = "<C-G>v",
      },
      visual = {
        variable_below = "g?v",
        variable_above = "g?V",
      },
    },
    commands = {
      -- toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
      reset_debug_prints_counter = "ResetDebugPrintsCounter",
    },
  },
  -- dependencies = {
  --   "echasnovski/mini.nvim" -- Needed for :ToggleCommentDebugPrints(NeoVim 0.9 only)
  -- },
  version = "*",
}

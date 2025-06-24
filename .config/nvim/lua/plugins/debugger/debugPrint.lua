return {
  "andrewferrier/debugprint.nvim",
  event = 'VeryLazy',
  opts = {
    keymaps = {
      normal = {
        plain_below = "g?p",
        plain_above = "g?P",
        variable_below = "g?v",
        variable_above = "g?V",
        variable_below_alwaysprompt = "",
        variable_above_alwaysprompt = "",
        textobj_below = "g?o",
        textobj_above = "g?O",
        toggle_comment_debug_prints = "",
        delete_debug_prints = "",
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
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
      reset_debug_prints_counter = "ResetDebugPrintsCounter",
    },
    -- … Other options
  },
  dependencies = {
    "echasnovski/mini.nvim" -- Needed for :ToggleCommentDebugPrints(NeoVim 0.9 only)
  },
  -- lazy = false,    -- Required to make line highlighting work before debugprint is first used
  version = "*",
}

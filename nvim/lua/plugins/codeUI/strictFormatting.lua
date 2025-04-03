return {
  'emileferreira/nvim-strict',
  event = 'VeryLazy',
  config = function()
    local strict = require 'strict'

    require('strict').setup {
      included_filetypes = nil,
      excluded_filetypes = { 'text', 'markdown', 'html' },
      excluded_buftypes = { 'help', 'nofile', 'terminal', 'prompt' },
      match_priority = -1,
      deep_nesting = {
        highlight = false,
        highlight_group = 'DiffDelete',
        depth_limit = 5,
        ignored_trailing_characters = ',',
        ignored_leading_characters = '.',
      },
      overlong_lines = {
        highlight = true,
        highlight_group = 'DiffDelete',
        length_limit = 80,
        split_on_save = false,
      },
      trailing_whitespace = {
        highlight = false,
        highlight_group = 'SpellBad',
        remove_on_save = true,
      },
      trailing_empty_lines = {
        highlight = false,
        highlight_group = 'SpellBad',
        remove_on_save = true,
      },
      space_indentation = {
        highlight = false,
        highlight_group = 'SpellBad',
        convert_on_save = false, --converts spaces to tabs
      },
      tab_indentation = {
        highlight = true,
        highlight_group = 'SpellBad',
        convert_on_save = true, --converts tabs to spaces
      },
      todos = {
        highlight = true,
        highlight_group = 'DiffAdd',
      },
    }

    -- local options = { noremap = true, silent = true }
    -- vim.keymap.set('n', '<Leader>tw', strict.remove_trailing_whitespace,
    -- options)
    -- vim.keymap.set('n', '<Leader>tl', strict.remove_trailing_empty_lines,
    -- options)
    -- vim.keymap.set('n', '<Leader>st', strict.convert_spaces_to_tabs, options)
    -- vim.keymap.set('n', '<Leader>ts', strict.convert_tabs_to_spaces, options)
    -- vim.keymap.set('n', '<Leader>ol', strict.split_overlong_lines, options)
  end,
}

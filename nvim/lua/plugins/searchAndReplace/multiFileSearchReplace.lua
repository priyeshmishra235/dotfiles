return {
  -- Used to search and replace text across multiple files
  -- :SReplace               - Search and replace
  -- :SReplaceAll            - Search and replace all including ignored files
  -- :SReplaceAndSave        - Search, replace and save
  -- :SReplaceAllAndSave     - Search, replace and save including ignored files
  's1n7ax/nvim-search-and-replace',
  event = 'VeryLazy',
  config = function()
    require('nvim-search-and-replace').setup {
      -- file patters to ignore
      ignore = { '**/node_modules/**', '**/.git/**', '**/.gitignore', '**/.gitmodules', 'build/**' },
      -- save the changes after replace
      update_changes = false,
      -- keymap for search and replace
      replace_keymap = '<leader>gr',
      -- keymap for search and replace ( this does not care about ignored files )
      replace_all_keymap = '<leader>gR',
      -- keymap for search and replace
      replace_and_save_keymap = '<leader>gu',
      -- keymap for search and replace ( this does not care about ignored files )
      replace_all_and_save_keymap = '<leader>gU',
    }
  end,
}

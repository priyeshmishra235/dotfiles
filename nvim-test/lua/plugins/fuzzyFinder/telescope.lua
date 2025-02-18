return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'sharkdp/fd'},
  config = function()
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc =
      'Telescopefind files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc =
      'Telescopelivegrep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc =
      'Telescopebuffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc =
      'Telescopehelptags' })
    require('telescope').setup {
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
        --[[mappings = {
          i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          },
        },]]
        --[[pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },]]
        --[[extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to
          -- configure
        },]]
      },
    }
  end,
}

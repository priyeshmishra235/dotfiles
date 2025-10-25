return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup {
      enabled = true,                                   -- Enables/disables auto creating, saving and restoring
      root_dir = vim.fn.stdpath 'data' .. '/sessions/', -- Root dir where sessions will be stored
      auto_save = true,                                 -- Enables/disables auto saving session on exit
      auto_restore = false,                             -- Enables/disables auto restoring session on start
      auto_create = false,                              -- Enables/disables auto creating new session files
      suppressed_dirs = {},                             -- Suppress session restore/create in certain directories
      -- ex: { '/some/dir/', '/projects/*' }
      allowed_dirs = nil,                               -- Allow session restore/create in certain directories
      -- doesn't auto create new sessions when opening Neovim in a new directory.
      auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
      -- A quick workaround for inability to auto create new sessions is to conditionally enable last session.
      use_git_branch = false,                                       -- Include git branch name in session name
      lazy_support = true,                                          -- Detect if Lazy.nvim is being used and wait for it
      bypass_save_filetypes = { 'alpha', 'dashboard', 'startify' }, --if none then nil
      close_unsupported_windows = true,                             -- Close unsupported windows before autosaving
      args_allow_single_directory = true,                           -- Allow saving session with a single directory argument
      args_allow_files_auto_save = false,                           -- Allow saving session even when launched with files
      continue_restore_on_error = true,                             -- Keep restoring session even if an error occurs
      show_auto_restore_notif = false,                              -- Disable notification on auto-restore
      cwd_change_handling = true,                                   -- Follow cwd changes, saving/restoring session automatically
      pre_cwd_changed_cmds = {
        'tabdo NERDTreeClose',                                      -- Close NERDTree before saving session
      },
      post_cwd_changed_cmds = {
        function()
          require('lualine').refresh() -- example refreshing the lualine status line _after_ the cwd changes
        end,
      },
      lsp_stop_on_restore = false, -- Stop LSP when restoring session
      log_level = 'error',         -- Sets the log level (debug, info, warn, error)
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = true,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          layout_config = {
            width = 0.5,
            height = 0.3,
          },
        },
      },
      session_control = {
        control_dir = vim.fn.stdpath 'data' .. '/auto_session/', -- Directory for session control files
        control_filename = 'session_control.json',               -- Session control file name
      },

      -- Keymaps
      vim.keymap.set('n', '<leader>sv', function()
        local default_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- suggest folder name
        vim.ui.input({ prompt = 'Save session as: ', default = default_name }, function(input)
          if input and input ~= '' then
            vim.cmd('SessionSave ' .. input)
          end
        end)
      end, { noremap = true, silent = true, desc = 'Save Session' }),

      vim.keymap.set('n', '<leader>sr', function()
        vim.ui.input({ prompt = 'Restore session named: ' }, function(input)
          if input and input ~= '' then
            vim.cmd('SessionRestore ' .. input)
          end
        end)
      end, { noremap = true, silent = true, desc = 'Restore Session' }),

      vim.keymap.set('n', '<leader>sd', function()
        vim.ui.input({ prompt = 'Delete session named: ' }, function(input)
          if input and input ~= '' then
            vim.cmd('SessionDelete ' .. input)
          end
        end)
      end, { noremap = true, silent = true, desc = 'Delete Session' })
    }

    -- ╭─────────╮
    -- │ keymaps │
    -- ╰─────────╯
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map('n', '<leader>st', ':SessionToggleAutoSave<CR>', opts)
    map('n', '<leader>ss', ':SessionSearch<CR>', opts)
  end,
}

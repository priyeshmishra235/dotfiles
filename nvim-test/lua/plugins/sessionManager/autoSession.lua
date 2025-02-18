return {
  'rmagatti/auto-session',
  lazy = false,

  opts = {
    enabled = true, -- Enables/disables auto creating, saving and restoring
    root_dir = vim.fn.stdpath 'data' .. '/sessions/', -- Root dir where sessions will be stored
    auto_save = true, -- Enables/disables auto saving session on exit
    auto_restore = true, -- Enables/disables auto restoring session on start
    auto_create = false, -- Enables/disables auto creating new session files
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' }, -- Suppress session restore/create in certain directories
    -- ex: { '/some/dir/', '/projects/*' }
    allowed_dirs = nil, -- Allow session restore/create in certain directories
    -- doesn't auto create new sessions when opening Neovim in a new directory.
    auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
    -- A quick workaround for inability to auto create new sessions is to conditionally enable last session.

    use_git_branch = false, -- Include git branch name in session name
    lazy_support = true, -- Detect if Lazy.nvim is being used and wait for it
    bypass_save_filetypes = { 'alpha', 'dashboard', 'startify' }, --if none then nil
    close_unsupported_windows = true, -- Close unsupported windows before autosaving
    args_allow_single_directory = true, -- Allow saving session with a single directory argument
    args_allow_files_auto_save = false, -- Allow saving session even when launched with files
    continue_restore_on_error = true, -- Keep restoring session even if an error occurs
    show_auto_restore_notif = false, -- Disable notification on auto-restore
    cwd_change_handling = true, -- Follow cwd changes, saving/restoring session automatically

    pre_cwd_changed_cmds = {
      'tabdo NERDTreeClose', -- Close NERDTree before saving session
    },

    post_cwd_changed_cmds = {
      function()
        require('lualine').refresh() -- example refreshing the lualine status line _after_ the cwd changes
      end,
    },

    lsp_stop_on_restore = false, -- Stop LSP when restoring session
    log_level = 'error', -- Sets the log level (debug, info, warn, error)

    -- ⚠️ Works only if Telescope.nvim is installed
    session_lens = {
      -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
      load_on_setup = true,
      previewer = false,
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
        -- layout_config = {
        --   width = 0.8, -- Can set width and height as percent of window
        --   height = 0.5,
        -- },
      },
    },

    -- Session control settings
    session_control = {
      control_dir = vim.fn.stdpath 'data' .. '/auto_session/', -- Directory for session control files
      control_filename = 'session_control.json', -- Session control file name
    },
  },
}

-- :SessionSave my_session - saves a session called `my_session` in `root_dir`

-- :SessionRestore - restores a session based on the `cwd` from `root_dir`
-- :SessionRestore my_session - restores `my_session` from `root_dir`

-- :SessionDelete - deletes a session based on the `cwd` from `root_dir`
-- :SessionDelete my_session - deletes `my_session` from `root_dir`

-- :SessionDisableAutoSave - disables autosave
-- :SessionDisableAutoSave! - enables autosave (still does all checks in the config)
-- :SessionToggleAutoSave - toggles autosave

-- :SessionPurgeOrphaned - removes all orphaned sessions with no working directory left.

-- :SessionSearch - open a session picker, uses Telescope or Snacks if installed, vim.ui.select otherwise

-- :Autosession search - open a vim.ui.select picker to choose a session to load.
-- :Autosession delete - open a vim.ui.select picker to choose a session to delete.

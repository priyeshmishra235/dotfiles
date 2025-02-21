return {
  'okuuva/auto-save.nvim',
  version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = 'ASToggle', -- optional for lazy loading on command
  event = { 'InsertLeave', 'TextChanged' }, -- optional for lazy loading on trigger events
  opts = {
    enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    trigger_events = { -- See :h events
      immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' }, -- vim events that trigger an immediate save
      defer_save = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
      cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
    },
    -- function that takes the buffer handle and determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    -- if set to `nil` then no specific condition is applied
    condition = nil,
    -- disables auto-save for specified file types:
    -- {
    --  condition = function(buf)
    --  local filetype = vim.fn.getbufvar(buf, "&filetype")
    --
    -- don't save for `sql` file types
    -- if vim.list_contains({ "sql" }, filetype) then
    --   return false
    --  end
    --    return true
    --  end
    -- }
    write_all_buffers = false, -- write all buffers when the current one meets `condition`
    noautocmd = false, -- do not execute autocmds when saving
    lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
    debounce_delay = 1000, -- delay after which a pending save is executed
    -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
    debug = false,
  },

  config = function()
    local group = vim.api.nvim_create_augroup('autosave', {}) -- Create augroup only once

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveWritePost',
      group = group,
      callback = function(opts)
        if opts.data and opts.data.saved_buffer then
          local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
          vim.notify('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime '%H:%M:%S', vim.log.levels.INFO)
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveEnable',
      group = group,
      callback = function()
        vim.notify('AutoSave enabled', vim.log.levels.INFO)
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'AutoSaveDisable',
      group = group,
      callback = function()
        vim.notify('AutoSave disabled', vim.log.levels.INFO)
      end,
    })
  end,
}

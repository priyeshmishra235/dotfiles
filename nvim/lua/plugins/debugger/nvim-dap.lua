-- Use this some day for profiling the code: https://github.com/t-troebst/perfanno.nvim
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    "nvim-neotest/nvim-nio"
  },
  event = 'VeryLazy',
  config = function()
    local dap = require("dap")

    -- DAP Keymaps
    local keymap = vim.keymap.set
    keymap('n', '<F5>', dap.continue)
    keymap('n', '<F10>', dap.step_over)
    keymap('n', '<F11>', dap.step_into)
    keymap('n', '<F12>', dap.step_out)
    keymap('n', '<Leader>b', dap.toggle_breakpoint)
    keymap('n', '<Leader>B', function() dap.set_breakpoint() end)
    keymap('n', '<Leader>lp', function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end)
    keymap('n', '<Leader>dr', dap.repl.open)
    keymap('n', '<Leader>dl', dap.run_last)

    -- Widgets
    local widgets = require('dap.ui.widgets')
    keymap({ 'n', 'v' }, '<Leader>dh', widgets.hover)
    keymap({ 'n', 'v' }, '<Leader>dp', widgets.preview)
    keymap('n', '<Leader>dw', function() widgets.centered_float(widgets.frames) end)
    keymap('n', '<Leader>ds', function() widgets.centered_float(widgets.scopes) end)

    -- ╭───────────────────────────╮
    -- │ C/C++/Rust using codelldb │
    -- ╰───────────────────────────╯
    dap.adapters.codelldb = {
      type = "executable",
      command = "codelldb", -- Use the command directly from PATH
      name = "codelldb",
      detached = false,     -- Keep this as is for Windows
    }
    dap.configurations.cpp = {
      {
        name = "Launch File",
        type = "codelldb",
        request = "launch",
        -- to automatically look for .exe
        -- program = function()
        --   -- Get full path to current file's directory
        --   local file_dir = vim.fn.expand('%:p:h')
        --
        --   -- Get the base filename without extension (e.g., 'main')
        --   local file_name = vim.fn.expand('%:t:r')
        --
        --   -- Build the expected executable path (Windows .exe style)
        --   local exe_path = file_dir .. '\\' .. file_name .. '.exe'
        --
        --   -- Check if that file exists
        --   if vim.fn.filereadable(exe_path) == 1 then
        --     return exe_path
        --   else
        --     -- Fallback if the executable doesn't exist
        --     return vim.fn.input('Executable not found! Enter path manually: ', file_dir .. '\\', 'file')
        --   end
        -- end,
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '\\', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
}

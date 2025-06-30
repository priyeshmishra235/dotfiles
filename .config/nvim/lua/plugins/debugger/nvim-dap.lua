-- Use this for profiling the code: https://github.com/t-troebst/perfanno.nvim
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
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      name = "codelldb",
    }
    -- 🔹 Custom function to find the *topmost* folder with CMakeLists.txt
    local function find_top_level_cmake(path)
      local prev = nil
      local current = vim.fn.fnamemodify(path, ':p:h')
      while current and current ~= prev do
        if vim.fn.filereadable(current .. '/CMakeLists.txt') == 1 then
          prev = current
          current = vim.fn.fnamemodify(current, ':h')
        else
          break
        end
      end
      return prev
    end

    dap.configurations.cpp = {
      {
        name = "Launch File",
        type = "codelldb",
        request = "launch",
        program = function()
          local filepath = vim.fn.expand('%:p')                 -- full path to current file
          local filedir = vim.fn.fnamemodify(filepath, ':h')    -- directory of current file
          local filename = vim.fn.fnamemodify(filepath, ':t:r') -- filename without extension
          local cmake_root = find_top_level_cmake(filepath)     -- top-most cmake root, if any

          if cmake_root then
            --CMake project: look for executable in build dir
            local bin_dir = cmake_root .. "/build/"
            local handle = io.popen("find '" .. bin_dir .. "' -type f -executable | head -n 1")
            local binary = handle:read("*a"):gsub("%s+$", "")
            handle:close()

            if binary == "" then
              vim.notify("No executable found in " .. bin_dir, vim.log.levels.ERROR)
              return ""
            else
              vim.notify("Launching CMake binary: " .. binary, vim.log.levels.INFO)
              return binary
            end
          else
            --No CMakeLists.txt: assume single file build in same folder
            local fallback_binary = filedir .. "/" .. filename
            if vim.fn.filereadable(fallback_binary) == 1 and vim.fn.getfperm(fallback_binary):sub(3, 3) == 'x' then
              vim.notify("Launching local binary: " .. fallback_binary, vim.log.levels.INFO)
              return fallback_binary
            else
              vim.notify("No executable found at " .. fallback_binary, vim.log.levels.ERROR)
              return ""
            end
          end
        end,
        '${workspaceFolder}',
        args = {},
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
}

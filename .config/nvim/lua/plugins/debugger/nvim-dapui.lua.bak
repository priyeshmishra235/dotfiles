return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  event = 'VeryLazy',
  config = function()
    local dapui = require("dapui")
    local dap = require("dap")

    -- DAP UI Setup
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", circular = "↺" },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = ""
        },
      },
      -- floating = {
      --   max_height = 0.8,
      --   max_width = 0.8,
      --   border = "rounded",
      --   mappings = {
      --     close = { "q", "<Esc>" }
      --   },
      -- },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.30 },
            { id = "breakpoints", size = 0.20 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 1,
          position = "left",
        },
        {
          elements = {
            -- { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 20,
          position = "bottom",
        },
      },
    })

    -- Auto-open and close UI
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- DAP UI Eval & Floating window
    -- vim.keymap.set('n', '<leader>df', function()
    --   dapui.float_element("scopes", { width = 80, height = 20, enter = true, position = "center" })
    -- end, { desc = "DAP UI Float Scopes" })

    -- vim.keymap.set('v', '<M-k>', function() require("dapui").eval() end, { desc = "DAP UI Eval Visual" })
  end,
}

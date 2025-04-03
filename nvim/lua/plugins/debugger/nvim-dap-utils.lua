return {
  "niuiic/dap-utils.nvim",
  event = 'VeryLazy',
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "nvim-telescope/telescope.nvim",
    "niuiic/core.nvim",
    -- "nvim-telescope/telescope-dap.nvim",
    -- uncomment if using optional at bottom
  },
  config = function()
    require("dap-utils").setup({
      -- ╭────────────────────╮
      -- │ DAP Utils for RUST │
      -- ╰────────────────────╯
      -- rust = function(run)
      --   local core = require("core")
      --   vim.cmd("!cargo build")
      --   local root_path = core.file.root_path()
      --   local target_dir = root_path .. "/target/debug/"
      --   local config = {
      --     name = "Launch",
      --     type = "lldb",
      --     request = "launch",
      --     program = nil,
      --     cwd = "${workspaceFolder}",
      --     stopOnEntry = false,
      --     args = {},
      --   }
      --   if core.file.file_or_dir_exists(target_dir) then
      --     local executable = {}
      --     for path, path_type in vim.fs.dir(target_dir) do
      --       if path_type == "file" then
      --         local perm = vim.fn.getfperm(target_dir .. path)
      --         if string.match(perm, "x", 3) then
      --           table.insert(executable, path)
      --         end
      --       end
      --     end
      --     if #executable == 1 then
      --       config.program = target_dir .. executable[1]
      --       run(config)
      --     else
      --       vim.ui.select(executable, { prompt = "Select executable" }, function(choice)
      --         if not choice then
      --           return
      --         end
      --         config.program = target_dir .. choice
      --         run(config)
      --       end)
      --     end
      --   else
      --     vim.ui.input({ prompt = "Path to executable: ", default = root_path .. "/target/debug/" }, function(input)
      --       config.program = input
      --       run(config)
      --     end)
      --   end
      -- end,
      -- ╭──────────────────────────╮
      -- │ DAP Utils for JAVASCRIPT │
      -- ╰──────────────────────────╯
      -- javascript = function(run)
      --   local core = require("core")
      --   run({
      --     {
      --       name = "Launch project",
      --       type = "pwa-node",
      --       request = "launch",
      --       cwd = "${workspaceFolder}",
      --       runtimeExecutable = "pnpm",
      --       runtimeArgs = { "debug" },
      --     },
      --     {
      --       name = "Launch cmd",
      --       type = "pwa-node",
      --       request = "launch",
      --       cwd = core.file.root_path(),
      --       runtimeExecutable = "pnpm",
      --       runtimeArgs = { "debug:cmd" },
      --     },
      --     {
      --       name = "Launch file",
      --       type = "pwa-node",
      --       request = "launch",
      --       program = "${file}",
      --       cwd = "${workspaceFolder}",
      --     },
      --     {
      --       name = "Attach",
      --       type = "pwa-node",
      --       request = "attach",
      --       processId = require("dap.utils").pick_process,
      --       cwd = "${workspaceFolder}",
      --     },
      --   })
      -- end,
    })

    -- Optional Keymaps
    local dap_utils = require("dap-utils")
    local keymap = vim.keymap.set
    keymap("n", "<Leader>dus", dap_utils.store_breakpoints, { desc = "Store Breakpoints" })
    keymap("n", "<Leader>dur", dap_utils.restore_breakpoints, { desc = "Restore Breakpoints" })
    keymap("n", "<Leader>duw", dap_utils.store_watches, { desc = "Store Watches" })
    keymap("n", "<Leader>dul", dap_utils.restore_watches, { desc = "Restore Watches" })
    keymap("n", "<Leader>dux", dap_utils.remove_watches, { desc = "Remove Watches" })
    keymap("n", "<Leader>dut", dap_utils.toggle_breakpoints, { desc = "Toggle Breakpoints" })
    keymap("n", "<Leader>duf", dap_utils.search_breakpoints, { desc = "Search Breakpoints" })
    -- ╭──────────────────────────────────╮
    -- │ UI CAN BE CONFIGURED IF REQUIRED │
    -- ╰──────────────────────────────────╯
    -- -- Telescope integration: Search breakpoints
    -- keymap("n", "<Leader>df", function()
    --   require("dap-utils").search_breakpoints(require("telescope.themes").get_dropdown({
    --     prompt_title = "Search DAP Breakpoints"
    --   }))
    -- end, { desc = "Search Breakpoints (Telescope)" })
    --
    -- -- Optional: Integrate telescope-dap if installed (more DAP controls via Telescope)
    -- local telescope = require("telescope")
    -- telescope.load_extension("dap")
    -- keymap("n", "<Leader>db", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "List Breakpoints (Telescope)" })
    -- keymap("n", "<Leader>dv", "<cmd>Telescope dap variables<CR>", { desc = "DAP Variables" })
    -- keymap("n", "<Leader>dfn", "<cmd>Telescope dap frames<CR>", { desc = "DAP Frames" })
  end
}

local M = {}

function M.launch_from_json(json_path)
  local dap = require("dap")
  local json = vim.fn.json_decode(vim.fn.readfile(json_path))

  dap.run({
    type = (json.type == "lldb" or json.type == nil) and "codelldb" or json.type,
    request = json.request or "launch",
    name = json.name or "Launch from JSON",
    program = json.program,
    args = json.args or {},
    cwd = json.cwd or vim.fn.getcwd(),
    stopOnEntry = json.stopOnEntry or false
  })
end

return M
-- ~/.config/nvim/lua/plugins/debugger/myDapLauncher.lua

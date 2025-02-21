return {
  'ms-jpq/coq_nvim',
  branch = 'coq',
  dependencies = {
    { 'ms-jpq/coq.artifacts', branch = 'artifacts' }, -- Precompiled binaries for speed
    { 'ms-jpq/coq.thirdparty', branch = '3p' }, -- Third-party sources (LSP, snippets, etc.)
    { 'L3MON4D3/LuaSnip' }, -- Snippet engine (Luasnip)
  },
  config = function()
    -- Load dependencies
    local status_coq, coq = pcall(require, 'coq')
    if not status_coq then
      vim.notify('COQ.nvim not found!', vim.log.levels.ERROR)
      return
    end

    local lspconfig = require 'lspconfig'

    -- COQ Settings (Advanced UI Customization)
    vim.g.coq_settings = {
      auto_start = 'shut-up', -- Auto-start COQ.nvim without prompting
      keymap = {
        recommended = false, -- Disable default COQ keymaps (we define our own)
        jump_to_mark = '<C-j>', -- Jump to snippet placeholders
      },
      display = {
        icons = { mode = 'full' }, -- Use full icons for completion menu
        ghost_text = { enabled = true }, -- Show ghost text (like VSCode inline hint)
        preview = {
          border = 'double', -- Custom preview window border (rounded, double, single, etc.)
          position = 'bottom', -- Show completion preview at the bottom
        },
        pum = {
          fast_close = false, -- Keep menu open for easier navigation
          y_max_len = 10, -- Maximum visible completion entries
        },
      },
      clients = {
        lsp = { always_on_top = {} }, -- Prioritize LSP suggestions
        snippets = { warn = {} }, -- No warnings for missing snippets
      },
      limits = {
        completion_auto_timeout = 0.8, -- Delay for auto-completion popup
        completion_manual_timeout = 0.1, -- Faster manual completion response
      },
    }

    -- List of LSP servers with COQ integration
    local servers = { 'lua_ls', 'tsserver', 'pyright', 'clangd', 'rust_analyzer', 'html', 'cssls' }
    for _, server in ipairs(servers) do
      if lspconfig[server] then
        lspconfig[server].setup(coq.lsp_ensure_capabilities {})
      else
        vim.notify('LSP server not found: ' .. server, vim.log.levels.WARN)
      end
    end

    -- LuaSnip Setup (Snippet Expansion Support)
    local status_snip, luasnip = pcall(require, 'luasnip')
    if status_snip then
      vim.api.nvim_set_keymap('i', '<C-k>', "<cmd>lua require'luasnip'.jump(1)<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('s', '<C-k>', "<cmd>lua require'luasnip'.jump(1)<CR>", { noremap = true, silent = true })
    else
      vim.notify('LuaSnip not found!', vim.log.levels.WARN)
    end

    -- Manual completion trigger key
    vim.api.nvim_set_keymap('i', '<C-Space>', 'coq#complete()', { silent = true, expr = true, noremap = true })

    -- Third-Party Integrations (More Completion Sources)
    local status_coq3p, _ = pcall(function()
      require 'coq_3p' {
        { src = 'nvimlua', short_name = 'nLUA', conf_only = false }, -- Neovim Lua API completion
        { src = 'bc', short_name = 'MATH', precision = 6 }, -- Math calculations
        { src = 'figlet', short_name = 'BIG' }, -- ASCII art with Figlet
        { src = 'copilot', short_name = 'AI' }, -- GitHub Copilot (if installed)
        { src = 'path', short_name = 'PATH' }, -- File path auto-completion
        { src = 'buffers', short_name = 'BUF' }, -- Buffer completion
      }
    end)

    if not status_coq3p then
      vim.notify('COQ 3rd party sources failed to load!', vim.log.levels.WARN)
    end

    -- Ensure COQ starts properly
    vim.schedule(function()
      vim.cmd 'COQnow --shut-up'
    end)
  end,
}

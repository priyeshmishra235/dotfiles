-- Custom code snippets for different purposes

-- Prevent LSP from overwriting Treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, Treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    -- Add a custom format function to show error codes
    format = function(diagnostic)
      local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
      return string.format('%s %s', code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = {
    source = 'always', -- Or "if_many"
  },
}

-- Make diagnostic background transparent
vim.cmd 'highlight DiagnosticVirtualText guibg=NONE'

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Keybinding to reload Neovim config
vim.keymap.set('n', '<leader>rr', function()
  -- Clear Lua cache for custom user modules
  for name, _ in pairs(package.loaded) do
    if name:match '^user' or name:match '^plugins' then
      package.loaded[name] = nil
    end
  end

  -- Reload Lazy.nvim safely
  local ok, lazy = pcall(require, 'lazy')
  if ok and lazy then
    lazy.reload()
    print '🔄 Lazy.nvim reloaded successfully!'
  else
    print '❌ Error: Lazy.nvim not found!'
  end
end, { noremap = true, silent = true, desc = 'Reload Neovim Config with Lazy.nvim' })

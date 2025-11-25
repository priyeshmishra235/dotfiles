-- ╭────────────────────────────────╮
-- │ Set default path for file tree │
-- ╰────────────────────────────────╯
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd('cd ' .. vim.fn.expand('$HOME/CodeBase/'))
  end,
})
----------------------------------------------------------------------
--                   Removes trailing whitespaces                   --
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
----------------------------------------------------------------------
--                   Removes trailing emptylines                    --
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[silent! %s#\($\n\s*\)\+\%$##]],
})
----------------------------------------------------------------------
--                      convert tabs to spaces                      --
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[:retab]],
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                QUIT SOME WINDOWS WITH Q                 │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'qf', 'man', 'oil', 'aerial-nav', 'query' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>bd<cr>', { silent = true, buffer = true })
  end,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                  QUIT DIFFVIEW WITH Q                   │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'DiffViewFiles', 'checkhealth' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>tabc<cr>', { silent = true, buffer = true })
  end,
})
-- ╭─────────────────────────────────────────────────────────╮
-- │                 OPEN HELP IN A NEW TAB                  │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = ':wincmd T',
})

-- ╭─────────────────────────────────────────────────────────╮
-- │       JUMP TO LAST EDIT POSITION ON OPENING FILE        │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

-- ╭─────────────────────────────────────────────────────────╮
-- │            DOCUMENT HIGHLIGHT ON CURSORHOLD             │
-- ╰─────────────────────────────────────────────────────────╯
local group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = group,
  callback = function()
    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if client.supports_method('textDocument/documentHighlight') then
        vim.lsp.buf.document_highlight()
        break
      end
    end
  end,
})
vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │               MESSAGE IF MACRO IS STOPPED               │
-- ╰─────────────────────────────────────────────────────────╯
local macro_group = vim.api.nvim_create_augroup('MacroRecording', { clear = true })
vim.api.nvim_create_autocmd('RecordingLeave', {
  group = macro_group,
  callback = function()
    print 'Macro recording stopped'
  end,
})
-- ╭─────────────────────────────────────────────────────────╮
-- │                 HIGHLIGHT SELECTET TEXT                 │
-- ╰─────────────────────────────────────────────────────────╯
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 100,
    }
  end,
})
-- ╭─────────────────────────────────────────────────────────╮
-- │                      Lua auto open                      │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.enable('lua_ls')
  end,
})

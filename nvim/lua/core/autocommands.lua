-- ╭─────────────────────────────────────────────────────────╮
-- │                 HIGHLIGHT SELECTET TEXT                 │
-- ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 100,
    }
  end,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │                    CHANGE CURSORLINE                    │
-- ╰─────────────────────────────────────────────────────────╯
-- vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
--     callback = function()
--         vim.opt.cursorline = true
--     end,
-- })
--
-- vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
--     callback = function()
--         vim.opt.cursorline = false
--     end,
-- })

-- ╭─────────────────────────────────────────────────────────╮
-- │       DISABLE INLAY HINTS FOR SPECIFIC FILETYPES        │
-- ╰─────────────────────────────────────────────────────────╯
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'zsh', 'conf' },
--     callback = function()
--         vim.lsp.inlay_hint.enable(0, false)
--     end,
-- })

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
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--     callback = function()
--         vim.lsp.buf.document_highlight()
--     end,
-- })
-- vim.api.nvim_create_autocmd('CursorMoved', {
--     callback = function()
--         vim.lsp.buf.clear_references()
--     end,
-- })

-- ╭─────────────────────────────────────────────────────────╮
-- │               MESSAGE IF MACRO IS STOPPED               │
-- ╰─────────────────────────────────────────────────────────╯
local macro_group = vim.api.nvim_create_augroup('MacroRecording', { clear = true })
vim.api.nvim_create_autocmd('RecordingLeave', {
  group = macro_group,
  callback = function()
    -- Display a message when macro recording stops
    print 'Macro recording stopped'
  end,
})

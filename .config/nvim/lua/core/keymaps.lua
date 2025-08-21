-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- Disable the spacebar key's default behavior in Normal and Visual modes
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Set Esc
map('i', 'kj', '<Esc>', opts)
map('i', 'KJ', '<Esc>', opts)
map('i', ';;', '<Esc>', opts)
map('i', 'jk', '<Esc>', opts)

-- save file
map('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
map('n', '<leader>sw', '<cmd>noautocmd w <CR>', opts)

-- Indent properly when entering insert mode on empty lines
map('n', 'i', function()
  if vim.api.nvim_get_current_line():find '^%s*$' then
    return [["_cc]]
  end
  return 'i'
end, { expr = true, desc = 'better i' })

-- quit file
map('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
map('n', 'x', '"_x', opts)

-- Vertical scroll and center
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
map('n', '<Up>', ':resize -1<CR>', opts)
map('n', '<Down>', ':resize +1<CR>', opts)
map('n', '<Left>', ':vertical resize -1<CR>', opts)
map('n', '<Right>', ':vertical resize +1<CR>', opts)

-- Buffers
map('n', '<Tab>', ':bnext<CR>', opts)
-- Already set as shift+i to go next buffer
map('n', '<S-Tab>', ':bprevious<CR>', opts)
-- Already set as shift+o to go to previous buffer
-- map('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
-- Already set as <leader>bd to close current buffer
-- map('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
map('n', '<leader>v', '<C-w>v', opts)  -- split window vertically
map('n', '<leader>h', '<C-w>s', opts)  -- split window horizontally
map('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
-- map('n', '<leader>xx', ':close<CR>', opts) -- close current split window

-- Navigate between splits
map('n', '<C-k>', ':wincmd k<CR>', opts)
map('n', '<C-j>', ':wincmd j<CR>', opts)
map('n', '<C-h>', ':wincmd h<CR>', opts)
map('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
-- map('n', '<leader>to', ':tabnew<CR>', opts)   -- open new tab
-- map('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
-- map('n', '<leader>tn', ':tabn<CR>', opts)     --  go to next tab
-- map('n', '<leader>tp', ':tabp<CR>', opts)     --  go to previous tab

-- Go to last change
map('n', 'g,', 'g;', { desc = 'Go to newest change' })
map('n', 'g;', 'g,', { desc = 'Go to last change' })

-- Add blank line without leaving normal mode
-- map('n', '<Space><UP>', "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>",
--   { desc = 'Add blank line below' })
-- map('n', '<Space><DOWN>', "<cmd>call append(line('.'), repeat([''], v:count1))<cr>",
--   { desc = 'Add blank line below' })

-- Jump to BoL and EoL without living instert mode
map('i', '<M-i>', '<Esc>I', { desc = 'Jump to Beginn of Line in insert mode' })
map('i', '<M-a>', '<Esc>A', { desc = 'Jump to End of Line in insert mode' })

-- Inner quotes
map({ 'o', 'x' }, 'iq', "i'", { desc = 'Inner Single Quotes' })
map({ 'o', 'x' }, 'iQ', 'i"', { desc = 'Inner Double Quotes' })

-- Outer quotes
map({ 'o', 'x' }, 'aq', "2i'", { desc = 'Around Single Quotes' })
map({ 'o', 'x' }, 'aQ', '2i"', { desc = 'Around Double Quotes' })
map({ 'o', 'x' }, "a'", "2i'", { desc = 'Around Single Quotes' })
map({ 'o', 'x' }, 'a"', '2i"', { desc = 'Around Double Quotes' })

-- Inner and outer rectangle brackets []
map({ 'o', 'x' }, 'ir', 'i[', { desc = 'Inner Brackets' })
map({ 'o', 'x' }, 'ar', 'a[', { desc = 'Inner Brackets' })

-- Toggle line wrapping
map('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
-- map('v', '<', '<gv', opts)
-- map('v', '>', '>gv', opts)

-- Keep last yanked when pasting
map('v', 'p', '"_dP', opts)

-- fix spelling mistakes
map('n', 'z.', '1z=', { desc = '󰓆 Fix Spelling' })

-- Don't yank empty lines with dd
map('n', 'dd', function()
  if vim.fn.getline '.' == '' then
    return '"_dd'
  end
  return 'dd'
end, { expr = true })

-- Tab / Shift‑Tab cycling in command‑line mode ─────────────────
vim.keymap.set("c", "<Tab>", function()
  return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Tab>"
end, opts)
vim.keymap.set("c", "<S-Tab>", function()
  return vim.fn.wildmenumode() == 1 and "<C-p>" or "<S-Tab>"
end, opts)

vim.keymap.set('n', '<Esc><Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

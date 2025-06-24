-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Set Esc
vim.keymap.set('i', 'kj', '<Esc>', opts)

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- Indent properly when entering insert mode on empty lines
vim.keymap.set('n', 'i', function()
  if vim.api.nvim_get_current_line():find '^%s*$' then
    return [["_cc]]
  end
  return 'i'
end, { expr = true, desc = 'better i' })

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -1<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +1<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -1<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +1<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
-- Already set as shift+i to go next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
-- Already set as shift+o to go to previous buffer
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts)   -- close buffer
-- Already set as <leader>bd to close current buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)      -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)      -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)     -- make split windows equal width & height
vim.keymap.set('n', '<leader>xx', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)   -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)     --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)     --  go to previous tab

-- Go to last change
vim.keymap.set('n', 'g,', 'g;', { desc = 'Go to newest change' })
vim.keymap.set('n', 'g;', 'g,', { desc = 'Go to last change' })

-- Add blank line without leaving normal mode
vim.keymap.set('n', '<Space><UP>', "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>",
  { desc = 'Add blank line below' })
vim.keymap.set('n', '<Space><DOWN>', "<cmd>call append(line('.'), repeat([''], v:count1))<cr>",
  { desc = 'Add blank line below' })

-- Jump to BoL and EoL without living instert mode
vim.keymap.set('i', '<M-i>', '<Esc>I', { desc = 'Jump to Beginn of Line in insert mode' })
vim.keymap.set('i', '<M-a>', '<Esc>A', { desc = 'Jump to End of Line in insert mode' })

-- Inner quotes
vim.keymap.set({ 'o', 'x' }, 'iq', "i'", { desc = 'Inner Single Quotes' })
vim.keymap.set({ 'o', 'x' }, 'iQ', 'i"', { desc = 'Inner Double Quotes' })

-- Outer quotes
vim.keymap.set({ 'o', 'x' }, 'aq', "2i'", { desc = 'Around Single Quotes' })
vim.keymap.set({ 'o', 'x' }, 'aQ', '2i"', { desc = 'Around Double Quotes' })
vim.keymap.set({ 'o', 'x' }, "a'", "2i'", { desc = 'Around Single Quotes' })
vim.keymap.set({ 'o', 'x' }, 'a"', '2i"', { desc = 'Around Double Quotes' })

-- Inner and outer rectangle brackets []
vim.keymap.set({ 'o', 'x' }, 'ir', 'i[', { desc = 'Inner Brackets' })
vim.keymap.set({ 'o', 'x' }, 'ar', 'a[', { desc = 'Inner Brackets' })

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- fix spelling mistakes
vim.keymap.set('n', 'z.', '1z=', { desc = '󰓆 Fix Spelling' })

-- Don't yank emty lines with dd
vim.keymap.set('n', 'dd', function()
  if vim.fn.getline '.' == '' then
    return '"_dd'
  end
  return 'dd'
end, { expr = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

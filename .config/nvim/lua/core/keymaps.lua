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

-- save file without auto-formatting
map('n', '<leader>sw', '<cmd>noautocmd w <CR>', opts)

-- Indent properly when entering insert mode on empty lines
map('n', 'i', function()
  if vim.api.nvim_get_current_line():find '^%s*$' then
    return [["_cc]]
  end
  return 'i'
end, { expr = true, desc = 'better i' })

-- delete single character without copying into register
map('n', 'x', '"_x', opts)

-- Vertical scroll and center
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Resize with arrows
map('n', '<Up>', ':resize -1<CR>', opts)
map('n', '<Down>', ':resize +1<CR>', opts)
map('n', '<Left>', ':vertical resize -1<CR>', opts)
map('n', '<Right>', ':vertical resize +1<CR>', opts)

-- Buffers
map('n', '<Tab>', ':bnext<CR>', opts)
map('n', '<S-Tab>', ':bprevious<CR>', opts)
map('n', '<leader>x', ':bdelete<CR>', opts)

-- Window management
map('n', '<leader>v', '<C-w>v', opts)  -- split window vertically
map('n', '<leader>h', '<C-w>s', opts)  -- split window horizontally
map('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height

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
-- map('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Keep last yanked when pasting
map('v', 'p', '"_dP', opts)

-- fix spelling mistakes
-- map('n', 'z.', '1z=', { desc = '󰓆 Fix Spelling' })

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

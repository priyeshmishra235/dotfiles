-- UI Settings
vim.wo.number = true
vim.o.relativenumber = true
vim.o.cursorline = false
vim.wo.signcolumn = 'yes'
vim.o.wrap = false
vim.o.linebreak = true
vim.o.termguicolors = true
vim.o.numberwidth = 4
vim.o.cmdheight = 0
-- 0->No tabline, 1->show if at least 2 tabs present, 2->always show
vim.o.showtabline = 0
-- 0→never show, 1→show when multiple windows, 2→always show
vim.o.laststatus = 2
vim.opt.colorcolumn = "81"

-- Window title
vim.opt.title = true
vim.opt.titlestring = [[%{expand('%:.')}]]

-- Indentation & Formatting
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Disable auto commenting on newline (c, r, o)
vim.opt.formatoptions:remove("cro")
vim.opt.iskeyword:append '-'

-- Clipboard & File Encoding
vim.o.clipboard = 'unnamedplus'
vim.o.fileencoding = 'utf-8'

-- Scrolling Behavior
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.pumheight = 10

-- Search Behavior
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.opt.magic = true

-- Window Splitting
vim.o.splitbelow = true
vim.o.splitright = true

-- Folding
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Undo & Backup
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true

-- Key Behavior
vim.o.whichwrap = 'bs<>[]hl'
vim.o.backspace = 'indent,eol,start'

-- Performance Tweaks
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Miscellaneous
vim.o.showmode = false
vim.o.breakindent = true
vim.o.conceallevel = 0
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles'
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
vim.opt.shortmess:append 'c'
vim.opt.shell = "/bin/zsh"
vim.opt.confirm = true
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, Treesitter's priority level

-- Cursor
vim.opt.guicursor = {
  -- Format: "mode-list:shape-blink/attributes"
  -- Modes: n=normal, v=visual, V=visual-line, b=visual-block,
  --        s=select, i=insert, r=replace, c=command-line, t=terminal, o=operator
  -- Shapes: block, ver{width%} (vertical bar), hor{height%} (horizontal line)
  -- Blink: blinkon0=none, blinkon1=slow, blinkon2=medium, blinkon3=fast
  "n-v-c:block-blinkon0",
  "i:block",
}

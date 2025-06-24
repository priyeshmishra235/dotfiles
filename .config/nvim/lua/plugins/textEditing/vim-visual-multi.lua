return {
  'mg979/vim-visual-multi',
  enabled = true,
  branch = 'master',
  init = function()
    vim.g.VM_maps = {
      ['Motion ,'] = '',
      ['Select l'] = '<C-Right>',
      ['Select h'] = '<C-Left>',
      ['Goto Next'] = '',
      ['Goto Prev'] = '',
      ['I BS'] = '',
    }
    -- Themes: 'codedark' | 'iceblue' | 'purplegray' | 'nord' | 'sand' | 'ocean' | 'olive' | 'spacesray'
    -- vim.g.VM_theme = 'ocean'
  end,
  keys = {
    { '<C-n>' },
    { '<C-Left>' },
    { '<C-Right>' },
    { '<C-Down>' },
    { '<C-Up>' },
    {
      'cp',
      'vip<Plug>(VM-Visual-Cursors)',
      desc = 'Create multicursors inner paragraph'
    },
    {
      '<M-s>',
      ':VMSearch',
      mode = 'x',
      desc = 'Search & create multicursors in visual mode'
    },
    {
      '<M-s>',
      ':%VMSearch',
      desc = 'Search & create multicursors'
    },
    {
      '<M-c>',
      '<Plug>(VM-Visual-Cursors)',
      mode = 'x',
      desc = 'Create multicursors in visual mode'
    },
  },
  -- Basic usage:
  --
  -- - Select words with Ctrl-N (like Ctrl-D in Sublime Text/VS Code)
  -- - Create cursors vertically with Ctrl-Down/Ctrl-Up
  -- - Select one character at a time with Shift-Arrows
  -- - Press n/N to get next/previous occurrence
  -- - Press [/] to select next/previous cursor
  -- - Press q to skip current and get next occurrence
  -- - Press Q to remove current cursor/selection
  -- - Start insert mode with i, a, I, A
  --
  -- Two main modes:
  --
  -- - In "cursor mode," commands work as they would in normal mode.
  -- - In "extend mode," commands work as they would in visual mode.
  --
  -- - Press Tab to switch between «cursor» and «extend» mode.
  --
  -- Most Vim commands work as expected (motions, `r` to replace characters, `~`
  -- to change case, etc).
}

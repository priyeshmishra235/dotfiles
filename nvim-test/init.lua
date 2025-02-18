require 'core.options' -- Load general options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then local lazyrepo =
  'https://github.com/folke/lazy.nvim.git' local out = vim.fn.system { 'git',
    'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath } if
    vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end
vim.opt.rtp:prepend(lazypath)

-- Notify if ripgrep not installed, checks on startup
if vim.fn.executable 'rg' == 0 then vim.notify("Ripgrep is not installed!
Telescope live_grep won't work.", vim.log.levels.WARN) end

require('lazy').setup {
  {
    --require 'lua.plugins.dashboard.dashboard',
    --require 'lua.plugins.dashboard.alpha',
    require 'lua.plugins.dashboard.startify',
    require 'plugins.fileManager.neotree',
    require 'plugins.fileManager.unsavedFileManager',
    require 'plugins.themesAndBackground.themery',
    require 'plugins.navBar.bufferLine',
    require 'plugins.navBar.deadColumn',
    require 'plugins.navBar.dropBar',
    require 'plugins.navBar.luaLine',
    require 'plugins.navBar.winBar',
    require 'plugins.utilities.bookmark',
    require 'plugins.utilities.codeMetrics',
    --require 'plugins.utilities.codeShot',
    require 'plugins.utilities.imageViewer',
    require 'plugins.utilities.noteTaking',
    require 'plugins.utilities.notificationManager',
    require 'plugins.utilities.pomodoro',
    require 'plugins.utilities.quitConfirm',
    require 'plugins.utilities.truncateLine',
    require 'plugins.utilities.wordHighlight',
    require 'plugins.utilities.whichKey',
    require 'plugins.utilities.mason',
    require 'plugins.editing.autosave',
    require 'plugins.editing.codeContext',
    --require 'plugins.editing.foldText',
    require 'plugins.editing.rainbowCurly',
    require 'plugins.editing.zenMode',
    require 'plugins.editing.dimInactiveCode',
    require 'plugins.editing.zenMode',
    require 'plugins.editing.textMove',
    require 'plugins.editing.undoTree',
    require 'plugins.editing.strictFormatting',
    require 'plugins.editing.hlChunk',
    require 'plugins.editing.autoIndent',
    require 'plugins.editing.autocompletion',
    require 'plugins.editing.comment',
    require 'plugins.editing.indent-blankline',
    require 'plugins.editing.none-ls',
    require 'plugins.editing.misc',
    require 'plugins.splitScreen.borderCurrWin',
    require 'plugins.splitScreen.winShift',
    require 'plugins.splitScreen.smartSplit',
    --require 'plugins.competitiveProgramming.leetcode',
    require 'plugins.competitiveProgramming.competiTest',
    require 'plugins.games.minesweeper',
    require 'plugins.games.cellularAutomaton',
    require 'plugins.games.vimBeGood',
    require 'plugins.sessionManager.autoSession',
    require 'plugins.git.gitFugitive',
    require 'plugins.git.gitSigns',
    require 'plugins.fuzzyFinder.telescope',
    require 'plugins.fuzzyFinder.nvimTreesitter',
    require 'plugins.fuzzyFinder.fzf',
  },
}
--Make Neovim background transparent
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight Folded guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]]
--Set default path for file tree
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd 'cd E:/CodeBase' -- Fix path format
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

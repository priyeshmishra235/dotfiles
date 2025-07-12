require 'core.options'
require 'core.keymaps'
require 'core.snippets'
require 'core.autocommands'
-- ╭────────────────────────────────╮
-- │ Set up the Lazy plugin manager │
-- ╰────────────────────────────────╯
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
-- ╭────────────╮
-- │ lazy Setup │
-- ╰────────────╯
require('lazy').setup {
  -- ╭─────────╮
  -- │ code UI │
  -- ╰─────────╯
  require 'plugins.codeUI.autopairs',
  require 'plugins.codeUI.rainbowCurly',
  -- require 'plugins.codeUI.hlChunk',
  -- require 'plugins.codeUI.deadColumn',
  -- require 'plugins.codeUI.strictFormatting',
  -- require 'plugins.codeUI.wordHighlight',
  -- require 'plugins.codeUI.codeRunner',
  -- require 'plugins.codeUI.carbon-now',
  -- require 'plugins.codeUI.dimInactiveCode',
  -- require 'plugins.codeUI.truncateLine',
  -- require 'plugins.codeUI.ufo',
  -- require 'plugins.codeUI.zenMode',
  -- ╭─────────────────────────╮
  -- │ competitive Programming │
  -- ╰─────────────────────────╯
  -- require 'plugins.competitiveProgramming.competiTest',
  -- require 'plugins.competitiveProgramming.leetcode',
  -- ╭─────────────────────────────╮
  -- │ fileManager and can't think │
  -- ╰─────────────────────────────╯
  require 'plugins.fileAndUndo.harpoon',
  require 'plugins.fileAndUndo.oil',
  -- require 'plugins.fileAndUndo.undoTree',
  -- ╭───────────╮
  -- │ telescope │
  -- ╰───────────╯
  require 'plugins.fuzzyFinder.flash',
  require 'plugins.fuzzyFinder.fzf',
  require 'plugins.fuzzyFinder.nvimTreesitter',
  require 'plugins.fuzzyFinder.telescope',
  -- require 'plugins.fuzzyFinder.tabForTelescope',
  -- ╭───────╮
  -- │ games │
  -- ╰───────╯
  -- require 'plugins.games.cellularAutomaton',
  -- ╭─────╮
  -- │ git │
  -- ╰─────╯
  -- require 'plugins.git.gitFugitive',
  require 'plugins.git.gitSigns',
  -- ╭─────────────────────╮
  -- │ LSP-related plugins │
  -- ╰─────────────────────╯
  require 'plugins.lsp.none-ls',
  require 'plugins.lsp.lspConfig',
  require 'plugins.lsp.nvim-cmp',
  require 'plugins.lsp.luasnip',
  require 'plugins.lsp.mason',
  require 'plugins.lsp.trouble',
  require 'plugins.lsp.refactoring',
  require 'plugins.lsp.glsl',
  -- require 'plugins.lsp.cmake-tools',
  -- require 'plugins.lsp.codeContext',
  -- require 'plugins.lsp.clangd-extensions',
  -- ╭─────╮
  -- │ DAP │
  -- ╰─────╯
  require 'plugins.debugger.nvim-dap',
  -- require 'plugins.debugger.debugPrint',
  require 'plugins.debugger.nvim-dap-virtual-text',
  require 'plugins.debugger.nvim-dapui',
  -- require 'plugins.debugger.nvim-dap-utils',
  -- require 'plugins.debugger.persistent-breakpoint',
  -- ╭───────────────────────╮
  -- │ Miscellaneous plugins │
  -- ╰───────────────────────╯
  -- require 'plugins.misc.autosave',
  require 'plugins.misc.pendulum',
  require 'plugins.misc.misc',
  -- require 'plugins.misc.cheatsheet',
  -- require 'plugins.misc.imageViewer',
  -- require 'plugins.misc.speedTyper',
  -- ╭────────────────────────╮
  -- │ Navigation Bar plugins │
  -- ╰────────────────────────╯
  require 'plugins.navigationBar.bufferLine',
  -- require 'plugins.navigationBar.luaLine',
  -- require 'plugins.navigationBar.dropBar',
  -- require 'plugins.navigationBar.winBar',
  -- ╭────────────────────────────╮
  -- │ UI Enhancements for Neovim │
  -- ╰────────────────────────────╯
  require 'plugins.nvimUI.alpha',
  require 'plugins.nvimUI.dressing',
  require 'plugins.nvimUI.notificationManager',
  require 'plugins.nvimUI.themery',
  -- ╭────────────────────────────╮
  -- │ Search and Replace plugins │
  -- ╰────────────────────────────╯
  -- require 'plugins.searchAndReplace.multiFileSearchReplace',
  -- require 'plugins.searchAndReplace.multiFileSearchReplace',
  -- require 'plugins.searchAndReplace.quickfix',
  -- require 'plugins.searchAndReplace.ripgrepUseAndLearn',
  -- ╭─────────────────────────╮
  -- │ Split Screen Management │
  -- ╰─────────────────────────╯
  -- require 'plugins.splitScreen.borderCurrWin',
  -- require 'plugins.splitScreen.smartSplit',
  -- require 'plugins.splitScreen.winShift',
  -- ╭──────────────────────╮
  -- │ Text Editing Plugins │
  -- ╰──────────────────────╯
  -- require 'plugins.textEditing.textMove',
  require 'plugins.textEditing.vim-visual-multi',
  require 'plugins.textEditing.comment',
  require 'plugins.textEditing.yanky',
  -- ╭─────────────────╮
  -- │ Utility Plugins │
  -- ╰─────────────────╯
  -- require 'plugins.utilities.autoSession',
  -- require 'plugins.utilities.bookmark',
  -- require 'plugins.utilities.pomodoro',
  require 'plugins.utilities.terminal',
  require 'plugins.utilities.whichKey',
}
-------
-- ╭────────────────────────────────────╮
-- │ Make Neovim background transparent │
-- ╰────────────────────────────────────╯
-- vim.cmd [[
--   highlight Normal guibg=NONE ctermbg=NONE
--   highlight NonText guibg=NONE ctermbg=NONE
--   highlight LineNr guibg=NONE ctermbg=NONE
--   highlight Folded guibg=NONE ctermbg=NONE
--   highlight EndOfBuffer guibg=NONE ctermbg=NONE
-- ]]
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

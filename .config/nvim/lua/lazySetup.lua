local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    { import = "plugins.codeUI" },
    { import = "plugins.programming" },
    -- { import = "plugins.debugger" },
    { import = "plugins.fileAndUndo" },
    { import = "plugins.fuzzyFinder" },
    -- { import = "plugins.games" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    -- { import = "plugins.misc" },
    { import = "plugins.navigationBar" },
    { import = "plugins.nvimUI" },
    { import = "plugins.textEditing" },
    { import = "plugins.utilities" },
  },
  {
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
  })

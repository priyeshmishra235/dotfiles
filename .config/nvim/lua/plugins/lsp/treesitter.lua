return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",  -- automatically update parsers
  event = "BufReadPost", -- lazy-load after a file is opened
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("nvim-treesitter failed to load!", vim.log.levels.WARN)
      return
    end

    configs.setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      ensure_installed = { "lua" },
      indent = { enable = true },
    }
  end,
}

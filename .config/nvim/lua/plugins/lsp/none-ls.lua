return {
  'nvimtools/none-ls.nvim',
  dependencies = { 'nvimtools/none-ls-extras.nvim', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',

  config = function()
    local null_ls = require 'null-ls'
    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    local completion = null_ls.builtins.completion
    -- ensure temp directory exists
    local temp_dir = vim.fn.stdpath("cache") .. "/null-ls-temp"
    vim.fn.mkdir(temp_dir, "p")
    null_ls.setup({
      temp_dir = temp_dir,
      sources = {
        -- ╭──────────────╮
        -- │ Code Actions │
        -- ╰──────────────╯
        code_actions.gitsigns,
        code_actions.refactoring.with({
          filetypes = { 'go', 'javascript', 'lua', 'python', 'typescript', 'c', 'cpp', 'java', 'rust', 'sh' },
          extra_filetypes = { 'html', 'css', 'scss', 'json', 'yaml', 'markdown', 'php' },
        }),
        -- ╭────────────╮
        -- │ Completion │
        -- ╰────────────╯
        completion.luasnip,
        completion.nvim_snippets,

        -- ╭────────────╮
        -- │ Formatters │
        -- ╰────────────╯
        formatting.codespell,
      },
    })

    -- Autoformat on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000, async = false }
      end,
    })
  end,
}
